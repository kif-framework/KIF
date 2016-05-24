//
//  KIFScrollViewDelegates.m
//  KIF
//
//  Created by Ashit Gandhi on 7/24/15.
//
//

#import "KIFScrollViewDelegates.h"
#import "KIFConstants.h"

@interface KIFScrollViewDelegate ()
@property (nonatomic, assign) BOOL scrollViewDidEndScrollingAnimation;
@end

typedef BOOL (^VisibilityTestBlock)();

@implementation KIFScrollViewDelegate

// UIScrollViewDelegate scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This ensures that scrollViewDidEndScrollingAnimation is always called,
    // whether the scrollview is animated or not,
    // and that it's always called after scrollViewDidScroll,
    // which could fire synchronously from within the scroll method, thus
    // completing before any waits have started
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(scrollViewDidEndScrollingAnimation:)
                                               object:nil];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:)
               withObject:nil
               afterDelay:0.1f];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(scrollViewDidEndScrollingAnimation:)
                                               object:nil];
    self.scrollViewDidEndScrollingAnimation = YES;
}

- (void)reset
{
    self.scrollViewDidEndScrollingAnimation = NO;
}

- (BOOL)waitForScrollCompleteOnView:(UIView *)view inScrollView:(UIScrollView *)scrollView
{
    // The UITableViewWrapperView (introduced in iOS7) gets in the way.
    // It doesn't update its content offset, so we cannot use it to judge if the cell is in view
    if ([NSStringFromClass([scrollView class]) isEqualToString:@"UITableViewWrapperView"] &&
        [scrollView.superview isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)scrollView.superview;
    }

    return [self waitForScrollViewDidEndScrollingAnimationOnView:^BOOL {
        CGRect elementFrame = [view.window convertRect:view.accessibilityFrame
                                                toView:scrollView];
        CGRect visibleRect = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y,
                                        CGRectGetWidth(scrollView.bounds), CGRectGetHeight(scrollView.bounds));

        return CGRectContainsRect(visibleRect, elementFrame);
    }];
}

- (BOOL)waitForScrollViewDidEndScrollingAnimationOnView:(UIView *)view inScrollView:(UIScrollView *)scrollView
{
    @autoreleasepool {
        NSDate *date;
        NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:KIF_WAIT_TIMEOUT_INTERVAL]; // max wait timeout
        CGRect viewFrame;
        CGRect visibleRect;
        do {
            viewFrame = [view.window convertRect:view.frame toView:scrollView];
            visibleRect = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y,
                                     CGRectGetWidth(scrollView.bounds), CGRectGetHeight(scrollView.bounds));

            date = [NSDate dateWithTimeIntervalSinceNow:KIF_RUNLOOP_INTERVAL];
            [[NSRunLoop currentRunLoop] runUntilDate:date];
            if ([date compare:timeout] == NSOrderedDescending) {
                return NO;
            }
        } while (!self.scrollViewDidEndScrollingAnimation || !CGRectContainsRect(visibleRect, viewFrame));
        return YES;
    }
}

- (BOOL)waitForScrollViewDidEndScrollingAnimationOnView:(VisibilityTestBlock)isVisibleBlock
{
    @autoreleasepool {
        NSDate *date;
        NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:KIF_WAIT_TIMEOUT_INTERVAL]; // max wait

        // Ensure that we pump the runloop at least once before bailing
        do {
            date = [NSDate dateWithTimeIntervalSinceNow:KIF_RUNLOOP_INTERVAL];
            [[NSRunLoop currentRunLoop] runUntilDate:date];
            if ([date compare:timeout] == NSOrderedDescending) {
                return NO;
            }
        } while (!self.scrollViewDidEndScrollingAnimation && !isVisibleBlock());
        return YES;
    }
}

@end

@implementation KIFCollectionViewDelegate

- (BOOL)waitForScrollCompleteToIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView
{
    return [self waitForScrollViewDidEndScrollingAnimationOnView:^BOOL {
        return [KIFCollectionViewDelegate isItemAtIndexPath:indexPath alreadyVisibleIn:collectionView];
    }];
}

+ (BOOL)isItemAtIndexPath:(NSIndexPath *)indexPath alreadyVisibleIn:(UICollectionView *)collectionView
{
    for (UICollectionViewCell * testCell in [collectionView visibleCells]) {
        NSIndexPath * itemIndexPath = [collectionView indexPathForCell:testCell];
        if (itemIndexPath.section == indexPath.section && itemIndexPath.item == indexPath.item) {
            CGRect itemRect = [testCell convertRect:testCell.frame toView:testCell.superview];
            itemRect = [collectionView convertRect:itemRect toView:collectionView.superview];
            CGRect collectionViewFrame = CGRectMake(collectionView.contentOffset.x, collectionView.contentOffset.y,
                                                    collectionView.bounds.size.width, collectionView.bounds.size.height);

            // Check the simplest contained case -- this works only if the item is visible without having to scroll at all
            BOOL contained = CGRectContainsRect(collectionView.bounds, testCell.frame);
            if (contained) {
                return YES;
            }

            // If the itemRect is larger than the CV or is positioned so that it can never be fully within the VC, only verify if its midpoint is within the CV
            if (itemRect.size.width > (collectionView.contentOffset.x + collectionViewFrame.size.width) ||
                itemRect.size.height > (collectionView.contentOffset.y + collectionViewFrame.size.height)) {
                return CGRectContainsPoint(collectionViewFrame,
                                           CGPointMake(itemRect.origin.x + (itemRect.size.width/2),
                                           itemRect.origin.y + (itemRect.size.height/2)));
            }

            // This does not work if the itemRect is larger than the collection view
            return CGRectContainsRect(collectionViewFrame, itemRect);
        }
    }
    return NO;
}

@end

@implementation KIFTableViewDelegate

+ (BOOL)isRowAtIndexPath:(NSIndexPath *)indexPath alreadyVisibleIn:(UITableView *)tableView
{
    CGRect rowRect = [tableView rectForRowAtIndexPath:indexPath];
    rowRect = [tableView convertRect:rowRect toView:tableView.superview];

    // If the row's size (in any dimension) is > the table view's size,
    // then we should return true if the row's midpoint is visible
    if (rowRect.size.width > (tableView.contentOffset.x + tableView.frame.size.width) ||
        rowRect.size.height > (tableView.contentOffset.y + tableView.frame.size.height)) {
        return CGRectContainsPoint(tableView.frame,
                                   CGPointMake(rowRect.origin.x + (rowRect.size.width/2),
                                   rowRect.origin.y + (rowRect.size.height/2)));
    }

    // Otherwise, check if the full rect is contained
    // This does not work if the rowRect is larger than the table view
    return CGRectContainsRect(tableView.frame, rowRect);
}

- (BOOL)waitForScrollCompleteToIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    return [self waitForScrollViewDidEndScrollingAnimationOnView:^BOOL {
        return [KIFTableViewDelegate isRowAtIndexPath:indexPath alreadyVisibleIn:tableView];
    }];
}

@end
