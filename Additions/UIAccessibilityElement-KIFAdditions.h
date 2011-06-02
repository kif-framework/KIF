//
//  UIAccessibilityElement-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/23/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIAccessibilityElement (KIFAdditions)

// Finds the view that this element is a part of
+ (UIView *)viewContainingAccessibilityElement:(UIAccessibilityElement *)element;

@end
