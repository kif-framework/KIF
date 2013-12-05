//
//  UITouch-KIFAdditions.m
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "UITouch-KIFAdditions.h"
#import "LoadableCategory.h"
#import <objc/runtime.h>

MAKE_CATEGORIES_LOADABLE(UITouch_KIFAdditions)

typedef struct {
    unsigned int _firstTouchForView:1;
    unsigned int _isTap:1;
    unsigned int _isDelayed:1;
    unsigned int _sentTouchesEnded:1;
    unsigned int _abandonForwardingRecord:1;
} UITouchFlags;

@interface UITouch () {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    // ivars declarations removed in 6.0
    NSTimeInterval  _timestamp;
    UITouchPhase    _phase;
    UITouchPhase    _savedPhase;
    NSUInteger      _tapCount;
    
    UIWindow        *_window;
    UIView          *_view;
    UIView          *_warpedIntoView;
    NSMutableArray  *_gestureRecognizers;
    NSMutableArray  *_forwardingRecord;
    
    CGPoint         _locationInWindow;
    CGPoint         _previousLocationInWindow;
    UInt8           _pathIndex;
    UInt8           _pathIdentity;
    float           _pathMajorRadius;
    UITouchFlags _touchFlags;
#endif
}
- (void)setGestureView:(UIView *)view;
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
#ifdef TARGET_RT_64_BIT
    Ivar tapCountIvar = class_getInstanceVariable([self class], "_tapCount");
    *(NSUInteger *)((__bridge void *)self + ivar_getOffset(tapCountIvar)) = 1;
    
    Ivar locationInWindowIvar = class_getInstanceVariable([self class], "_locationInWindow");
    *(CGPoint *)((__bridge void *)self + ivar_getOffset(locationInWindowIvar)) = point;
    
    Ivar previousLocationInWindowIvar = class_getInstanceVariable([self class], "_previousLocationInWindow");
    *(CGPoint *)((__bridge void *)self + ivar_getOffset(previousLocationInWindowIvar)) = point;
#else
    _tapCount = 1;
    _locationInWindow =	point;
	_previousLocationInWindow = _locationInWindow;
#endif
    
	UIView *hitTestView = [window hitTest:point withEvent:nil];
    
#ifdef TARGET_RT_64_BIT
    object_setInstanceVariable(self, "_window", [window retain]);
    object_setInstanceVariable(self, "_view", [hitTestView retain]);
    
    Ivar phaseIvar = class_getInstanceVariable([self class], "_phase");
    *(UITouchPhase *)((__bridge void *)self + ivar_getOffset(phaseIvar)) = UITouchPhaseBegan;
    
    Ivar touchFlagsIvar = class_getInstanceVariable([self class], "_touchFlags");
    ((UITouchFlags *)((__bridge void *)self + ivar_getOffset(touchFlagsIvar)))->_firstTouchForView = 1;
    ((UITouchFlags *)((__bridge void *)self + ivar_getOffset(touchFlagsIvar)))->_isTap = 1;
    
    Ivar timestampIvar = class_getInstanceVariable([self class], "_timestamp");
    *(NSTimeInterval *)((__bridge void *)self + ivar_getOffset(timestampIvar)) = [[NSProcessInfo processInfo] systemUptime];
#else
    _window = [window retain];
    _view = [hitTestView retain];
    
    _phase = UITouchPhaseBegan;
    _touchFlags._firstTouchForView = 1;
    _touchFlags._isTap = 1;
    _timestamp = [[NSProcessInfo processInfo] systemUptime];
#endif
    
    if ([self respondsToSelector:@selector(setGestureView:)]) {
        [self setGestureView:hitTestView];
    }
    
	return self;
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)view;
{
    return [self initAtPoint:[view.window convertPoint:point fromView:view] inWindow:view.window];
}
    
- (void)setPhase:(UITouchPhase)phase;
{
#ifdef TARGET_RT_64_BIT
    Ivar phaseIvar = class_getInstanceVariable([self class], "_phase");
    *(UITouchPhase *)((__bridge void *)self + ivar_getOffset(phaseIvar)) = phase;
    
    Ivar timestampIvar = class_getInstanceVariable([self class], "_timestamp");
    *(NSTimeInterval *)((__bridge void *)self + ivar_getOffset(timestampIvar)) = [[NSProcessInfo processInfo] systemUptime];
#else
	_phase = phase;
	_timestamp = [[NSProcessInfo processInfo] systemUptime];
#endif
}

//
// setLocationInWindow:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
#ifdef TARGET_RT_64_BIT
    Ivar previousLocationInWindowIvar = class_getInstanceVariable([self class], "_previousLocationInWindow");
    Ivar locationInWindowIvar = class_getInstanceVariable([self class], "_locationInWindow");
    
    *(CGPoint *)((__bridge void *)self + ivar_getOffset(previousLocationInWindowIvar)) = *(CGPoint *)((__bridge void *)self + ivar_getOffset(locationInWindowIvar));
    *(CGPoint *)((__bridge void *)self + ivar_getOffset(locationInWindowIvar)) = location;
    
    Ivar timestampIvar = class_getInstanceVariable([self class], "_timestamp");
    *(NSTimeInterval *)((__bridge void *)self + ivar_getOffset(timestampIvar)) = [[NSProcessInfo processInfo] systemUptime];
#else
	_previousLocationInWindow = _locationInWindow;
	_locationInWindow = location;
	_timestamp = [[NSProcessInfo processInfo] systemUptime];
#endif
}

@end
