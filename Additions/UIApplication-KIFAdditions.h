//
//  UIApplication-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <UIKit/UIKit.h>

#define UIApplicationCurrentRunMode ([[UIApplication sharedApplication] currentRunLoopMode])

/*!
 @abstract When mocking @c -openURL:, this notification is posted.
 */
UIKIT_EXTERN NSString *const UIApplicationDidMockOpenURLNotification;

/*!
 @abstract The key for the opened URL in the @c UIApplicationDidMockOpenURLNotification notification.
 */
UIKIT_EXTERN NSString *const UIApplicationOpenedURLKey;

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
 @returns The topmost window containing a @c UIDimmingView.
 */
- (UIWindow *)dimmingViewWindow;

/*!
 @returns All windows in the application, including the key window even if it does not appear in @c -windows.
 */
- (NSArray *)windowsWithKeyWindow;

/*!
 @returns The current run loop mode.
 */
- (CFStringRef)currentRunLoopMode;

/*!
 @abstract Swizzles the run loop modes so KIF can better switch between them.
 */
+ (void)swizzleRunLoop;

/*!
 @abstract Starts mocking requests to @c -openURL:, announcing all requests with a notification.
 @discussion After calling this method, whenever @c -openURL: is called a notification named @c UIApplicationDidMockOpenURLNotification with the URL in the @c UIApplicationOpenedURL will be raised and the normal behavior will be cancelled.
 @param returnValue The value to return when @c -openURL: is called.
 */
+ (void)startMockingOpenURLWithReturnValue:(BOOL)returnValue;

/*!
 @abstract Stops the application from mocking requests to @c -openURL:.
 */
+ (void)stopMockingOpenURL;

@end
