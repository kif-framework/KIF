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

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
    // Go through the array of windows in reverse order to process the frontmost window first.
    // When several elements with the same accessibilitylabel are present the one in front will be picked.
    for (UIWindow *window in [self.windowsWithKeyWindow reverseObjectEnumerator]) {
        UIAccessibilityElement *element = [window accessibilityElementWithLabel:label accessibilityValue:value traits:traits];
        if (element) {
            return element;
        }
    }
    
    return nil;
}

- (UIAccessibilityElement *)accessibilityElementMatchingBlock:(BOOL(^)(UIAccessibilityElement *))matchBlock;
{
    for (UIWindow *window in [self.windowsWithKeyWindow reverseObjectEnumerator]) {
        UIAccessibilityElement *element = [window accessibilityElementMatchingBlock:matchBlock];
        if (element) {
            return element;
        }
    }
    
    return nil;
}

- (UIWindow *)keyboardWindow;
{
    for (UIWindow *window in self.windowsWithKeyWindow) {
        if ([NSStringFromClass([window class]) isEqual:@"UITextEffectsWindow"]) {
            return window;
        }
    }
    
    return nil;
}

- (UIWindow *)pickerViewWindow;
{
    for (UIWindow *window in self.windowsWithKeyWindow) {
        NSArray *pickerViews = [window subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"];
        if (pickerViews.count > 0) {
            return window;
        }
    }
    
    return nil;
}

- (NSArray *)windowsWithKeyWindow
{
    NSMutableArray *windows = self.windows.mutableCopy;
    UIWindow *keyWindow = self.keyWindow;
    if (![windows containsObject:keyWindow]) {
        [windows addObject:keyWindow];
    }
    return [windows autorelease];
}

@end
