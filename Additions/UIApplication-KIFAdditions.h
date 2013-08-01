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

/*!
 @abstract Finds an accessibility element with a matching label, value, and traits across all windows in the application starting at the frontmost window.
 @param label The accessibility label of the element to search for.
 @param value The accessibility value of the element to search for.  If @c nil, all values will be accepted.
 @param traits The accessibility traits of the element to search for. Elements that do not include at least these traits are ignored.
 @return The found accessibility element or @c nil if the element could not be found.
 */
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @abstract Finds an accessibility element where @c matchBlock returns @c YES, across all windows in the application starting at the fronmost window.
 @discussion This method should be used if @c accessibilityElementWithLabel:accessibilityValue:traits: does not meet your requirements.  For example, if you are searching for an element that begins with a pattern or if of a certain view type.
 @param matchBlock.  A block to be performed on each element to see if it passes.
 */
- (UIAccessibilityElement *)accessibilityElementMatchingBlock:(BOOL(^)(UIAccessibilityElement *))matchBlock;

/*!
 @returns The window containing the keyboard or @c nil if the keyboard is not visible.
 */
- (UIWindow *)keyboardWindow;

/*!
 @returns The topmost window containing a @c UIPickerView.
 */
- (UIWindow *)pickerViewWindow;

/*!
 @returns All windows in the application, including the key window even if it does not appear in @c -windows.
 */
- (NSArray *)windowsWithKeyWindow;

@end
