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
    CGRect viewFrame = [self convertRect:view.frame fromView:view.superview];
    CGRect visibleFrame = self.frame;
    visibleFrame.origin = self.contentOffset;
    
    if (CGRectContainsRect(visibleFrame, viewFrame)) {
        return;
    }
    
    [self scrollRectToVisible:viewFrame animated:YES];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.3, false);
}

@end
