//
//  UITouch-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UITouch-KIFAdditions.h"
#import "UIView+KIFPrivateAPI.h"
#import "LoadableCategory.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "IOHIDEvent+KIF.h"

MAKE_CATEGORIES_LOADABLE(UITouch_KIFAdditions)

typedef struct {
    unsigned int _firstTouchForView:1;
    unsigned int _isTap:1;
    unsigned int _isDelayed:1;
    unsigned int _sentTouchesEnded:1;
    unsigned int _abandonForwardingRecord:1;
} UITouchFlags;

@interface UITouch ()


- (void)setWindow:(UIWindow *)window;
- (void)setView:(UIView *)view;
- (void)setTapCount:(NSUInteger)tapCount;
- (void)setIsTap:(BOOL)isTap;
- (void)setTimestamp:(NSTimeInterval)timestamp;
- (void)setPhase:(UITouchPhase)touchPhase;
- (void)setGestureView:(UIView *)view;
- (void)_setLocationInWindow:(CGPoint)location resetPrevious:(BOOL)resetPrevious;
- (void)_setIsFirstTouchForView:(BOOL)firstTouchForView;
- (void)_setIsTapToClick:(BOOL)tapToClick;

- (void)_setHidEvent:(IOHIDEventRef)event;
- (void)_setEdgeType:(NSInteger)edgeType;

@end

@implementation UITouch (KIFAdditions)

- (id)initInView:(UIView *)view;
{
    CGRect frame = view.frame;    
    CGPoint centerPoint = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    return [self initAtPoint:centerPoint inView:view];
}

- (id)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window;
{
	self = [super init];
	if (self == nil) {
        return nil;
    }
    
    // Create a fake tap touch
    [self setWindow:window]; // Wipes out some values.  Needs to be first.
    
    [self setTapCount:1];
    [self _setLocationInWindow:point resetPrevious:YES];
    
    UIView *hitTestView = [self kif_getHitTestViewInWindow:window atPoint:point];
    [self setView:hitTestView];
    
    [self setPhase:UITouchPhaseBegan];
    
    if ([self respondsToSelector:@selector(_setIsFirstTouchForView:)]) {
        [self _setIsFirstTouchForView:YES];
    } else {
        [self _setIsTapToClick:YES];

        // We modify the touchFlags ivar struct directly.
        // First entry is _firstTouchForView
        Ivar flagsIvar = class_getInstanceVariable(object_getClass(self), "_touchFlags");
        ptrdiff_t touchFlagsOffset = ivar_getOffset(flagsIvar);
        char *flags = (__bridge void *)self + touchFlagsOffset;
        *flags = *flags | (char)0x01;
    }
    
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    
    if ([self respondsToSelector:@selector(setGestureView:)]) {
        [self setGestureView:hitTestView];
    }
    
    // Starting with iOS 9, internal IOHIDEvent must be set for UITouch object
    [self kif_setHidEvent];
    
	return self;
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)view;
{
    return [self initAtPoint:[view.window convertPoint:point fromView:view] inWindow:view.window];
}

//
// setLocationInWindow:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self _setLocationInWindow:location resetPrevious:NO];
}

- (void)setPhaseAndUpdateTimestamp:(UITouchPhase)phase
{
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self setPhase:phase];
}

- (void)setIsFromEdge:(BOOL)isFromEdge
{
    NSInteger edgeType = isFromEdge ? 4 : 0;
    [self _setEdgeType:edgeType];
}

- (void)kif_setHidEvent
{
    IOHIDEventRef event = kif_IOHIDEventWithTouches(@[self]);
    [self _setHidEvent:event];
    CFRelease(event);
}

/*!
 @abstract Beginning with iOS 18, there is  @c _UIHitTestContext structure introduced for hit testing SwiftUI views. This method tries to mimic that behaviour.
 @returns The view that should be assigned to the touch gesture.
 */
- (UIView *)kif_getHitTestViewInWindow:(UIWindow *)window atPoint:(CGPoint)point
{
    UIView *hitTestView = [window hitTest:point withEvent:nil];
    
    if (@available(iOS 18.0, *)) {
        static Class UIHitTestContextClass;
        static SEL contextWithPointAndRadiusSel;
        static BOOL canCreateContext;
        static BOOL canHitTestWithContext;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIHitTestContextClass = NSClassFromString(@"_UIHitTestContext");
            contextWithPointAndRadiusSel = NSSelectorFromString(@"contextWithPoint:radius:");
            canCreateContext = UIHitTestContextClass && [UIHitTestContextClass respondsToSelector:contextWithPointAndRadiusSel];
            canHitTestWithContext = [[UIView class] instancesRespondToSelector:@selector(_hitTestWithContext:)];
        });
        
        if (canCreateContext && canHitTestWithContext) {
            id hitTestContext = ((id (*)(id, SEL, CGPoint, CGFloat))objc_msgSend)(UIHitTestContextClass, contextWithPointAndRadiusSel, point, 0);
            
            if (hitTestContext) {
                /*
                 From observation - this can be either of following types:
                    - UIView type (e.g. when using UIViewRepresentable inside SwiftUI)
                    - specialized SwiftUI view compatible with UIView,
                    - newly introduced structure SwiftUI.UIKitGestureContainer implementing UIResponder interface.
                    What's important it seems it is compatible with setView:(UIView *) method.
                 */
                id foundResponder = NULL;
                UIView *currentView = hitTestView;
                
                while(foundResponder == NULL && currentView != NULL) {
                    foundResponder = [currentView _hitTestWithContext:hitTestContext];
                    currentView = [currentView superview];
                }
                
                if (foundResponder) {
                    return foundResponder;
                }
            }
        }
    }
    
    return hitTestView;
}

@end
