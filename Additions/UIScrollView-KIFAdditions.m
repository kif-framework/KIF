//
//  UIScrollView-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/22/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UIScrollView-KIFAdditions.h"
#import "LoadableCategory.h"
#import "UIApplication-KIFAdditions.h"
#import "UIView-KIFAdditions.h"


MAKE_CATEGORIES_LOADABLE(UIScrollView_KIFAdditions)


@implementation UIScrollView (KIFAdditions)

- (void)scrollViewToVisible:(UIView *)view animated:(BOOL)animated;
{
    BOOL needsUpdate = NO;
    
    CGRect viewFrame = [self convertRect:view.frame fromView:view.superview];
    CGFloat viewMaxX = viewFrame.origin.x + viewFrame.size.width;
    CGFloat viewMaxY = viewFrame.origin.y + viewFrame.size.height;
    CGFloat scrollViewMaxX = self.frame.size.width;
    CGFloat scrollViewMaxY = self.frame.size.height;
    
    CGPoint offsetPoint = self.contentOffset;
    if (viewMaxX > (scrollViewMaxX + offsetPoint.x)) {
        // The view is to the right of the view port, so scroll it just into view
        offsetPoint.x = viewMaxX - scrollViewMaxX;
        needsUpdate = YES;
    } else if (viewMaxX < 0.0) {
        offsetPoint.x = 0;
        needsUpdate = YES;
    }
    
    if (viewMaxY > (scrollViewMaxY + offsetPoint.y)) {
        // The view is below the view port, so scroll it just into view
        offsetPoint.y = viewMaxY - scrollViewMaxY;
        needsUpdate = YES;
    } else if (viewMaxY < 0.0) {
        offsetPoint.y = 0;
        needsUpdate = YES;
    }
    
    if (needsUpdate) {
        [self setContentOffset:offsetPoint animated:animated];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.2, false);
    }
}

@end
