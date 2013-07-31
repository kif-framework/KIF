//
//  UIAccessibilityElement-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/23/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "NSError-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIScrollView-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "LoadableCategory.h"
#import "KIFTestActor.h"

MAKE_CATEGORIES_LOADABLE(UIAccessibilityElement_KIFAdditions)


@implementation UIAccessibilityElement (KIFAdditions)

+ (UIView *)viewContainingAccessibilityElement:(UIAccessibilityElement *)element;
{
    while (element && ![element isKindOfClass:[UIView class]]) {
        element = [element accessibilityContainer];
    }
    
    return (UIView *)element;
}

+ (BOOL)accessibilityElement:(out UIAccessibilityElement **)foundElement view:(out UIView **)foundView withLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable error:(out NSError **)error;
{
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:value traits:traits];
    if (!element) {
        if (error) {
            element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:traits];
            // For purposes of a better error message, see if we can find the view, just not a view with the specified value.
            if (value && [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:traits]) {
                *error = [NSError KIFErrorWithLocalizedDescriptionWithFormat:@"Found an accessibility element with the label \"%@\", but with the value \"%@\", not \"%@\"", label, element.accessibilityValue, value];
                
                // Check the traits, too.
            } else if (traits != UIAccessibilityTraitNone && [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone]) {
                *error = [NSError KIFErrorWithLocalizedDescriptionWithFormat:@"Found an accessibility element with the label \"%@\", but not with the traits \"%llu\"", label, traits];
                
            } else {
                *error = [NSError KIFErrorWithLocalizedDescriptionWithFormat:@"Failed to find accessibility element with the label \"%@\"", label];
            }
        }
        return NO;
    }
    
    // Make sure the element is visible
    UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
    if (!view) {
        if (error) {
            *error = [NSError KIFErrorWithLocalizedDescriptionWithFormat:@"Cannot find view containing accessibility element with the label \"%@\"", label];
        }
        return NO;
    }
    
    // Scroll the view to be visible if necessary
    UIScrollView *scrollView = (UIScrollView *)view;
    while (scrollView && ![scrollView isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)scrollView.superview;
    }
    if (scrollView) {
        if ((UIAccessibilityElement *)view == element) {
            [scrollView scrollViewToVisible:view animated:YES];
        } else {
            CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:scrollView];
            [scrollView scrollRectToVisible:elementFrame animated:YES];
        }
        
        // Give the scroll view a small amount of time to perform the scroll.
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.3, false);
    }
    
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        if (error) {
            *error = [NSError KIFErrorWithLocalizedDescriptionWithFormat:@"Application is ignoring interaction events"];
        }
        return NO;
    }
    
    // There are some issues with the tappability check in UIWebViews, so if the view is a UIWebView we will just skip the check.
    if ([NSStringFromClass([view class]) isEqualToString:@"UIWebBrowserView"]) {
        if (foundElement) { *foundElement = element; }
        if (foundView) { *foundView = view; }
        return YES;
    }
    
    if (mustBeTappable) {
        // Make sure the view is tappable
        if (![view isTappable]) {
            if (error) {
                *error = [NSError KIFErrorWithLocalizedDescriptionWithFormat:@"Accessibility element with label \"%@\" is not tappable. It may be blocked by other views.", label];
            }
            return NO;
        }
    } else {
        // If we don't require tappability, at least make sure it's not hidden
        if ([view isHidden]) {
            if (error) {
                *error = [NSError KIFErrorWithLocalizedDescriptionWithFormat:@"Accessibility element with label \"%@\" is hidden.", label];
            }
            return NO;
        }
    }
    
    if (foundElement) { *foundElement = element; }
    if (foundView) { *foundView = view; }
    return YES;
}

@end
