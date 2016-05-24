//
//  KIFScrollViewDelegates.h
//  KIF
//
//  Created by Ashit Gandhi on 7/24/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * @abstract @c Generic scroll view delegate that allows to reliably wait for scrolling to complete.
 * @discussion Objects of this class can serve a scroll view delegate. 
               Note that scrolling has to start for the @c waitForScrollComplete* methods to be called.
 */
@interface KIFScrollViewDelegate : NSObject<UIScrollViewDelegate>

/*!
 * @abstract Resets scroll completion state if you want to reuse the same delegate object.
 */
- (void)reset;

/*!
 * @abstract Scrolling wait function for generic scroll views.
 */
- (BOOL)waitForScrollCompleteOnView:(UIView *)view inScrollView:(UIScrollView *)scrollView;

@end

@interface KIFCollectionViewDelegate : KIFScrollViewDelegate<UICollectionViewDelegate>

/*!
 * @abstract Scrolling wait function using collection view cell visibility logic.
 */
- (BOOL)waitForScrollCompleteToIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView;

@end

@interface KIFTableViewDelegate : KIFScrollViewDelegate<UITableViewDelegate>

/*!
 * @abstract Scrolling wait function using table views cell visibility logic.
 */
- (BOOL)waitForScrollCompleteToIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

@end
