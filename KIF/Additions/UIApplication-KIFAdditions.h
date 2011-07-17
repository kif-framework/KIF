//
//  UIApplication-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIApplication (KIFAdditions)

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;

- (UIWindow *)keyboardWindow;
- (UIWindow *)pickerViewWindow;

@end
