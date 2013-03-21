//
//  UIApplication-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UIApplication-KIFAdditions.h"
#import "LoadableCategory.h"
#import "UIView-KIFAdditions.h"


MAKE_CATEGORIES_LOADABLE(UIApplication_KIFAdditions)


@implementation UIApplication (KIFAdditions)

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label;
{
    return [self accessibilityElementWithLabel:label traits:UIAccessibilityTraitNone];
}

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    return [self accessibilityElementWithLabel:label accessibilityValue:nil traits:traits];
}

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
	return [self accessibilityElementWithLabel:label accessibilityValue:value traits:traits class:nil];
}

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits class:(Class)class;
{
	// Go through the array of windows in reverse order to process the frontmost window first.
    // When several elements with the same accessibilitylabel are present the one in front will be picked.
    for (UIWindow *window in [self.windows reverseObjectEnumerator]) {
        UIAccessibilityElement *element = [window accessibilityElementWithLabel:label accessibilityValue:value traits:traits class:class];
        if (element) {
            return element;
        }
    }
    
    return nil;
}

- (UIAccessibilityElement *)accessibilityElementMatchingBlock:(BOOL(^)(UIAccessibilityElement *))matchBlock;
{
    for (UIWindow *window in [self.windows reverseObjectEnumerator]) {
        UIAccessibilityElement *element = [window accessibilityElementMatchingBlock:matchBlock];
        if (element) {
            return element;
        }
    }
    
    return nil;
}

- (UIAccessibilityElement *)accessibilityElementWithLabelLike:(NSString *)label;
{
    return [self accessibilityElementWithLabelLike:label traits:UIAccessibilityTraitNone];
}

- (UIAccessibilityElement *)accessibilityElementWithLabelLike:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    return [self accessibilityElementWithLabelLike:label accessibilityValue:nil traits:traits];
}

- (UIAccessibilityElement *)accessibilityElementWithLabelLike:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
	return [self accessibilityElementWithLabelLike:label accessibilityValue:nil traits:traits class:nil];
}
- (UIAccessibilityElement *)accessibilityElementWithLabelLike:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits class:(Class)class;
{
	// Go through the array of windows in reverse order to process the frontmost window first.
    // When several elements with the same accessibilitylabel are present the one in front will be picked.
    for (UIWindow *window in [self.windows reverseObjectEnumerator]) {
        UIAccessibilityElement *element = [window accessibilityElementWithLabelLike:label accessibilityValue:value traits:traits class:class];
        if (element) {
            return element;
        }
    }
    
    return nil;
}

- (UIWindow *)keyboardWindow;
{
    for (UIWindow *window in self.windows) {
        if ([NSStringFromClass([window class]) isEqual:@"UITextEffectsWindow"]) {
            return window;
        }
    }
    
    return nil;
}

- (UIWindow *)pickerViewWindow;
{
    for (UIWindow *window in [self windows]) {
        NSArray *pickerViews = [window subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"];
        if (pickerViews.count > 0) {
            return window;
        }
    }
    
    return nil;
}

- (UIAlertView *)alertView
{
    NSArray* windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        for (UIView *view in [window subviews]) {
            if ([view isKindOfClass:[UIAlertView class]]) {
                return (UIAlertView*) view;
            }
        }
    }
    return nil;
}

@end
