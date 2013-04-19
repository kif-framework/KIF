//
//  UIApplication-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <UIKit/UIKit.h>


@interface UIApplication (KIFAdditions)

- (UIAccessibilityElement *)accessibilityElementWithIdentifier:(NSString *)identifier;
- (UIAccessibilityElement *)accessibilityElementWithIdentifier:(NSString *)identifier traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementWithIdentifier:(NSString *)identifier accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementMatchingBlock:(BOOL(^)(UIAccessibilityElement *))matchBlock;

- (UIWindow *)keyboardWindow;
- (UIWindow *)pickerViewWindow;

@end
