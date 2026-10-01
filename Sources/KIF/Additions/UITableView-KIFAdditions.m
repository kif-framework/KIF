//
//  UITableView-KIFAdditions.m
//  KIF
//
//  Created by Hilton Campbell on 4/12/14.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UITableView-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "NSError-KIFAdditions.h"

@implementation UITableView (KIFAdditions)

#define DRAG_STEP_DISTANCE 5

- (BOOL)dragCell:(UITableViewCell *)cell toIndexPath:(NSIndexPath *)indexPath error:(NSError **)error;
{
    UIView *sourceReorderControl = [[cell subviewsWithClassNameOrSuperClassNamePrefix:@"UITableViewCellReorderControl"] lastObject];
    if (!sourceReorderControl) {
        if (error) {
            *error = [NSError KIFErrorWithFormat:@"Failed to find reorder control for cell"];
        }
        return NO;
    }
    
    CGPoint sourcePoint = [self convertPoint:CGPointCenteredInRect(sourceReorderControl.bounds) fromView:sourceReorderControl];
    
    // If section < 0, search from the end of the table.
    if (indexPath.section < 0) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.numberOfSections + indexPath.section];
    }
    
    // If row < 0, search from the end of the section.
    if (indexPath.row < 0) {
        indexPath = [NSIndexPath indexPathForRow:[self numberOfRowsInSection:indexPath.section] + indexPath.row inSection:indexPath.section];
    }
    
    CGRect destinationCellRect = [self rectForRowAtIndexPath:indexPath];
    CGFloat destinationDragY = CGPointCenteredInRect(destinationCellRect).y;

    // In iOS11, the behavior for dragging table rows has been changed to be dependent on the direction that they are being dragged
    NSOperatingSystemVersion iOS11 = {11, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS11]) {
        if (destinationDragY - sourcePoint.y > 0) {
            // Dragging Down
            destinationDragY += destinationCellRect.size.height;
        }
    }
    CGPoint destinationPoint = CGPointMake(sourcePoint.x, destinationDragY);

    // Keep the whole gesture inside the visible area so the table does not auto-scroll under it.
    [self scrollToKeepReorderDragBetweenY:sourcePoint.y andY:destinationDragY margin:destinationCellRect.size.height];

    // Create the touch (there should only be one touch object for the whole drag)
    UITouch *touch = [[UITouch alloc] initAtPoint:sourcePoint inView:self];
    [touch setPhaseAndUpdateTimestamp:UITouchPhaseBegan];
    
    UIEvent *eventDown = [self eventWithTouch:touch];
    [[UIApplication sharedApplication] kif_sendEvent:eventDown];
    
    // Hold long enough to enter reordering mode
    CFRunLoopRunInMode(UIApplicationCurrentRunMode, 0.2, false);
    
    CGPoint currentLocation = sourcePoint;
    while (currentLocation.y < destinationPoint.y - DRAG_STEP_DISTANCE || currentLocation.y > destinationPoint.y + DRAG_STEP_DISTANCE) {
        if (currentLocation.y < destinationPoint.y) {
            currentLocation.y += DRAG_STEP_DISTANCE;
        } else {
            currentLocation.y -= DRAG_STEP_DISTANCE;
        }
        
        [touch setLocationInWindow:[self.window convertPoint:currentLocation fromView:self]];
        [touch setPhaseAndUpdateTimestamp:UITouchPhaseMoved];
        
        UIEvent *eventDrag = [self eventWithTouch:touch];
        [[UIApplication sharedApplication] kif_sendEvent:eventDrag];
        
        CFRunLoopRunInMode(UIApplicationCurrentRunMode, 0.01, false);
    }
    
    // Hold long enough for the animations to catch up
    CFRunLoopRunInMode(UIApplicationCurrentRunMode, 0.2, false);
    
    [touch setPhaseAndUpdateTimestamp:UITouchPhaseEnded];
    
    UIEvent *eventUp = [self eventWithTouch:touch];
    [[UIApplication sharedApplication] kif_sendEvent:eventUp];
    
    // Dispatching the event doesn't actually update the first responder, so fake it
    if (touch.view == self && [self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }
    return YES;
}

/*!
 @abstract Scrolls so that both ends of a reorder drag sit at least @c margin inside the
 table's visible, inset adjusted viewport.
 @discussion While a row is being reordered the table auto-scrolls whenever the touch is near
 the edge of that viewport. The rows then move underneath the finger, so the cell is dropped
 on a different index than the one the drag aimed at. How close to the edge is "near" varies
 by iOS version, and a bar overlapping the bottom of the table is enough to pull the
 destination into the zone. Scrolling both ends of the drag clear of the edges up front keeps
 the table still for the whole gesture and makes the drop index depend only on where the
 touch goes. If the two ends are too far apart to be on screen together then the drag has to
 rely on auto-scroll as before, so the content offset is left alone.
 */
- (void)scrollToKeepReorderDragBetweenY:(CGFloat)startY andY:(CGFloat)endY margin:(CGFloat)margin;
{
    UIEdgeInsets insets = self.adjustedContentInset;
    CGFloat viewportHeight = self.bounds.size.height - insets.top - insets.bottom;
    CGFloat lowestY = MIN(startY, endY) - margin;
    CGFloat highestY = MAX(startY, endY) + margin;

    if (viewportHeight <= 0 || highestY - lowestY > viewportHeight) {
        return;
    }

    CGFloat viewportTop = self.contentOffset.y + insets.top;
    CGFloat offsetY;
    if (highestY > viewportTop + viewportHeight) {
        offsetY = highestY - viewportHeight - insets.top;
    } else if (lowestY < viewportTop) {
        offsetY = lowestY - insets.top;
    } else {
        return;
    }

    CGFloat minimumOffsetY = -insets.top;
    CGFloat maximumOffsetY = MAX(minimumOffsetY, self.contentSize.height + insets.bottom - self.bounds.size.height);
    offsetY = MIN(MAX(offsetY, minimumOffsetY), maximumOffsetY);

    [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY) animated:NO];

    // Let the table lay out the rows that just scrolled into view before the drag starts.
    CFRunLoopRunInMode(UIApplicationCurrentRunMode, 0.1, false);
}

@end
