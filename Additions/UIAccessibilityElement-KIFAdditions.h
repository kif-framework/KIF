//
//  UIAccessibilityElement-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/23/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <UIKit/UIKit.h>


@interface UIAccessibilityElement (KIFAdditions)

// Finds the view that this element is a part of
+ (UIView *)viewContainingAccessibilityElement:(UIAccessibilityElement *)element;

+ (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value tappable:(BOOL)mustBeTappable traits:(UIAccessibilityTraits)traits error:(out NSError **)error;

@end
