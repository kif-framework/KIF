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


@implementation UITouch (KIFAdditions)

- (id)initInView:(UIView *)view;
{
    CGRect frame = view.frame;    
    CGPoint centerPoint = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    return [self initAtPoint:centerPoint inView:view];
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)view;
{
	self = [super init];
	if (self == nil) {
        return nil;
    }
    
    point = [view.window convertPoint:point fromView:view];
    
    // Create a fake tap touch
    _tapCount = 1;
    _locationInWindow =	point;
	_previousLocationInWindow = _locationInWindow;
    
	UIView *target = [view.window hitTest:_locationInWindow withEvent:nil];
    
    _window = [view.window retain];
    _view = [target retain];
    _phase = UITouchPhaseBegan;
    _touchFlags._firstTouchForView = 1;
    _touchFlags._isTap = 1;
    _timestamp = [NSDate timeIntervalSinceReferenceDate];
    _gestureView = [view retain];
    
    // The gesture recognizers for the touch are the compiled list from all of the views in the view stack at the touch point
    NSMutableArray *gestureRecognizers = [[NSMutableArray alloc] init];
    UIView *superview = view;
    while (superview) {
        if (superview.gestureRecognizers.count) {
            [gestureRecognizers addObjectsFromArray:superview.gestureRecognizers];
        }
        
        superview = superview.superview;
    }
    
    _gestureRecognizers = gestureRecognizers;
    
	return self;
}
    
- (void)setPhase:(UITouchPhase)phase;
{
	_phase = phase;
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
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
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
}

@end
