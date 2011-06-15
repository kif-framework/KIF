//
//  UIView-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "UIView-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "UITouchEvent-KIFExposure.h"
#import <objc/runtime.h>


@interface NSObject (UIWebDocumentViewInternal)

- (void)tapInteractionWithLocation:(CGPoint)point;

@end


@implementation UIView (KIFAdditions)

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label
{
    return [self accessibilityElementWithLabel:label traits:UIAccessibilityTraitNone];
}

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    return [self accessibilityElementWithLabel:label accessibilityValue:nil traits:traits];
}

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
    // In case multiple elements with the same label exist, prefer ones that are currently visible
    UIAccessibilityElement *matchingButHiddenElement = nil;
    
    BOOL labelsMatch = [self.accessibilityLabel isEqual:label];
    BOOL traitsMatch = ((self.accessibilityTraits) & traits) == traits;
    BOOL valuesMatch = !value || [value isEqual:self.accessibilityValue];
    
    if (labelsMatch && valuesMatch && traitsMatch) {
        if (self.tappable) {
            return (UIAccessibilityElement *)self;
        } else {
            matchingButHiddenElement = (UIAccessibilityElement *)self;
        }
    }
    
    // Check the subviews first. Even if the receiver says it's an accessibility container,
    // the returned objects are UIAccessibilityElementMockViews (which aren't actually views)
    // rather than the real subviews it contains. We want the real views if possible.
    // UITableViewCell is such an offender.
    for (UIView *view in self.subviews) {
        UIAccessibilityElement *element = [view accessibilityElementWithLabel:label accessibilityValue:value traits:traits];
        if (!element) {
            continue;
        }
        
        UIView *viewForElement = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        CGRect accessibilityFrame = [viewForElement.window convertRect:element.accessibilityFrame toView:viewForElement];
        
        if ([viewForElement isTappableInRect:accessibilityFrame]) {
            return element;
        } else {
            matchingButHiddenElement = element;
        }
    }
    
    NSMutableArray *elementStack = [NSMutableArray arrayWithObject:self];
    
    while (elementStack.count) {
        UIAccessibilityElement *element = [elementStack lastObject];
        [elementStack removeLastObject];
        
        BOOL labelsMatch = [element.accessibilityLabel isEqual:label];
        BOOL traitsMatch = ((element.accessibilityTraits) & traits) == traits;
        BOOL valuesMatch = !value || [value isEqual:element.accessibilityValue];
        
        if (labelsMatch && valuesMatch && traitsMatch) {
            UIView *viewForElement = [UIAccessibilityElement viewContainingAccessibilityElement:element];
            CGRect accessibilityFrame = [viewForElement.window convertRect:element.accessibilityFrame toView:viewForElement];

            if ([viewForElement isTappableInRect:accessibilityFrame]) {
                return element;
            } else {
                matchingButHiddenElement = element;
                continue;
            }
        }
        
        // If the view is an accessibility container, and we didn't find a matching subview,
        // then check the actual accessibility elements
        NSInteger accessibilityElementCount = element.accessibilityElementCount;
        if (accessibilityElementCount == 0 || accessibilityElementCount == NSNotFound) {
            continue;
        }
        
        for (NSInteger accessibilityElementIndex = 0; accessibilityElementIndex < accessibilityElementCount; accessibilityElementIndex++) {
            UIAccessibilityElement *subelement = [element accessibilityElementAtIndex:accessibilityElementIndex];
            
            [elementStack addObject:subelement];
        }
    }
        
    return matchingButHiddenElement;
}

- (UIView *)subviewWithClassNamePrefix:(NSString *)prefix;
{
    for (UIView *view in self.subviews) {
        if ([NSStringFromClass([view class]) hasPrefix:prefix]) {
            return view;
        }
        
        UIView *matchingSubview = [view subviewWithClassNamePrefix:prefix];
        if (matchingSubview) {
            return matchingSubview;
        }
    }
    
    return nil;
}

- (UIView *)subviewWithClassNameOrSuperClassNamePrefix:(NSString *)prefix;
{
    for (UIView *view in self.subviews) {
        Class klass = [view class];
        while (klass) {
            if ([NSStringFromClass(klass) hasPrefix:prefix]) {
                return view;
            }
            
            klass = [klass superclass];
        }
        
        UIView *matchingSubview = [view subviewWithClassNameOrSuperClassNamePrefix:prefix];
        if (matchingSubview) {
            return matchingSubview;
        }
    }
    
    return nil;
}

- (BOOL)isAncestorOfFirstResponder;
{
    if ([self isFirstResponder]) {
        return YES;
    }
    return [self.superview isAncestorOfFirstResponder];
}

- (void)flash;
{
	UIColor *originalBackgroundColor = [self.backgroundColor retain];
    for (NSUInteger i = 0; i < 5; i++) {
        self.backgroundColor = [UIColor yellowColor];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
        self.backgroundColor = [UIColor blueColor];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
    }
    self.backgroundColor = originalBackgroundColor;
    [originalBackgroundColor release];
}

- (void)tap;
{
    CGRect frame;
    if ([self isKindOfClass:[UIWindow class]]) {
        frame = self.frame;
    } else {
        frame = [self.window convertRect:self.frame fromView:self.superview];
    }
    
    CGPoint centerPoint = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    
    [self tapAtPoint:centerPoint];
}

- (void)tapAtPoint:(CGPoint)point;
{
    // Web views don't handle touches in a normal fashion, but they do have a method we can call to tap them
    id /*UIWebBrowserView*/ webBrowserView = nil;
    
    if ([NSStringFromClass([self class]) isEqual:@"UIWebBrowserView"]) {
        webBrowserView = self;
    } else if ([self isKindOfClass:[UIWebView class]]) {
        id webViewInternal = nil;
        object_getInstanceVariable(self, "_internal", (void **)&webViewInternal);
        object_getInstanceVariable(webViewInternal, "browserView", (void **)&webBrowserView);
    }
    
    if (webBrowserView) {
        [webBrowserView tapInteractionWithLocation:point];
        return;
    }
    
    // Handle touches in the normal way for other views
    UITouch *touch = [[UITouch alloc] initAtPoint:point inView:self];
    [touch setPhase:UITouchPhaseBegan];
    
    UIEvent *event = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touch];
    [[UIApplication sharedApplication] sendEvent:event];
    
    [touch setPhase:UITouchPhaseEnded];
    [[UIApplication sharedApplication] sendEvent:event];
    
    // Dispatching the event doesn't actually update the first responder, so fake it
    if (touch.view == self && [self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }
    
    [event release];
    [touch release];
}

- (void)dragFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
{
    // Handle touches in the normal way for other views
    UITouch *touchDown = [[UITouch alloc] initAtPoint:startPoint inView:self];
    [touchDown setPhase:UITouchPhaseBegan];
    
    UIEvent *eventDown = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touchDown];
    [[UIApplication sharedApplication] sendEvent:eventDown];
    
    UITouch *touchDrag = [[UITouch alloc] initAtPoint:CGPointMidPoint(startPoint, endPoint) inView:self];
    [touchDrag setPhase:UITouchPhaseMoved];
    
    UITouch *touchUp = [[UITouch alloc] initAtPoint:endPoint inView:self];
    [touchUp setPhase:UITouchPhaseMoved];
    
    UIEvent *eventDrag = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touchDrag];
    [[UIApplication sharedApplication] sendEvent:eventDrag];
    
    UIEvent *eventDrag2 = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touchUp];
    [[UIApplication sharedApplication] sendEvent:eventDrag2];
    
    [touchUp setPhase:UITouchPhaseEnded];
    
    UIEvent *eventUp = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touchUp];
    
    [[UIApplication sharedApplication] sendEvent:eventUp];
    
    // Dispatching the event doesn't actually update the first responder, so fake it
    if (touchUp.view == self && [self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
    }
    
    [eventDown release];
    [eventUp release];
    [touchDown release];
    [touchUp release];
}

// Is this view currently on screen?
- (BOOL)isTappable;
{
    return [self isTappableInRect:self.bounds];
}

- (BOOL)isTappableInRect:(CGRect)rect;
{
    CGPoint tappablePoint = [self tappablePointInRect:rect];
    
    return !isnan(tappablePoint.x);
}

- (CGPoint)tappablePointInRect:(CGRect)rect;
{
    // Start at the top and recurse down
    CGRect frame = [self.window convertRect:rect fromView:self];
    
    UIView *hitView = nil;
    CGPoint tapPoint = CGPointZero;
    
    // Mid point
    tapPoint = CGPointCenteredInRect(frame);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([hitView isDescendantOfView:self]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Top left
    tapPoint = CGPointMake(frame.origin.x + 1.0f, frame.origin.y + 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([hitView isDescendantOfView:self]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Top right
    tapPoint = CGPointMake(frame.origin.x + 1.0f + frame.size.width - 1.0f, frame.origin.y + 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([hitView isDescendantOfView:self]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Bottom left
    tapPoint = CGPointMake(frame.origin.x + 1.0f, frame.origin.y + frame.size.height - 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([hitView isDescendantOfView:self]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    // Bottom right
    tapPoint = CGPointMake(frame.origin.x + frame.size.width - 1.0f, frame.origin.y + frame.size.height - 1.0f);
    hitView = [self.window hitTest:tapPoint withEvent:nil];
    if ([hitView isDescendantOfView:self]) {
        return [self.window convertPoint:tapPoint toView:self];
    }
    
    return CGPointMake(NAN, NAN);
}

@end
