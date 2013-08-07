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


MAKE_CATEGORIES_LOADABLE(UITouch_KIFAdditions)


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
    struct {
        unsigned int _firstTouchForView:1;
        unsigned int _isTap:1;
        unsigned int _isDelayed:1;
        unsigned int _sentTouchesEnded:1;
        unsigned int _abandonForwardingRecord:1;
    } _touchFlags;
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
    _tapCount = 1;
    _locationInWindow =	point;
	_previousLocationInWindow = _locationInWindow;
    
	UIView *hitTestView = [window hitTest:_locationInWindow withEvent:nil];
    
    _window = [window retain];
    _view = [hitTestView retain];
    if ([self respondsToSelector:@selector(setGestureView:)]) {
        [self setGestureView:hitTestView];
    }
    _phase = UITouchPhaseBegan;
    _touchFlags._firstTouchForView = 1;
    _touchFlags._isTap = 1;
    _timestamp = [[NSProcessInfo processInfo] systemUptime];

	return self;
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)view;
{
    return [self initAtPoint:[view.window convertPoint:point fromView:view] inWindow:view.window];
}
    
- (void)setPhase:(UITouchPhase)phase;
{
	_phase = phase;
	_timestamp = [[NSProcessInfo processInfo] systemUptime];
}

//
// setLocationInWindow:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
	_previousLocationInWindow = _locationInWindow;
	_locationInWindow = location;
	_timestamp = [[NSProcessInfo processInfo] systemUptime];
}

@end
