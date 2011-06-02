//
//  UIAccessibilityElement-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/23/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "UIAccessibilityElement-KIFAdditions.h"


@implementation UIAccessibilityElement (KIFAdditions)

+ (UIView *)viewContainingAccessibilityElement:(UIAccessibilityElement *)element;
{
    while (element && ![element isKindOfClass:[UIView class]]) {
        element = [element accessibilityContainer];
    }
    
    return (UIView *)element;
}

@end
