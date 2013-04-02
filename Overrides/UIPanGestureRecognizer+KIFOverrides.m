//
//  UIPanGestureRecognizer+KIFOverrides.m
//  KIF
//
//  Created by Nate Chandler on 3/26/13.
//
//

#import "UIPanGestureRecognizer+KIFOverrides.h"
#import "NSObject+MGSupersequentImplementation.h"
#import "NSObject+BNRAssociatedDictionary.h"
#import "UITouch+KIFExposers.h"
#import "UIEvent+KIFAssociations.h"
#import "KIFUIPanGestureVelocitySample.h"
#import "UIPanGestureRecognizer+KIFExposers.h"

@interface UIPanGestureRecognizer (KIFOverridesInteral)
@property (nonatomic) UIEvent *previousEvent;
@end

@implementation UIPanGestureRecognizer (KIFOverrides)

- (void)_updateGestureWithEvent:(UIEvent *)event
{
	if (self.previousEvent) {
		self.previousVelocitySample = self.velocitySample;
		
		KIFUIPanGestureVelocitySample *velocitySample = [[KIFUIPanGestureVelocitySample alloc] init];
		
		UITouch *newTouch = event.allTouches.anyObject;
		UITouch *oldTouch = self.previousEvent.kif_associatedTouches.anyObject;
		
		velocitySample.dt = newTouch.timestamp - oldTouch.timestamp;
		velocitySample.end = newTouch.kif_locationInWindow;
		velocitySample.start = newTouch.kif_previousLocationInWindow;
		self.velocitySample = velocitySample;
		[velocitySample release];
	}
	self.previousEvent = event;
	
	invokeSupersequent(event);
}

- (CGPoint)velocityInView:(UIView *)view
{
	CGPoint res= CGPointZero;
	
	KIFUIPanGestureVelocitySample *velocitySample = self.velocitySample;
	
	CGPoint start = velocitySample.start;
	CGPoint end = velocitySample.end;
	double dt = velocitySample.dt;
	
	res = CGPointMake((end.x - start.x) / dt, (end.y - start.y) / dt);
	
	return res;
}

-(void)touchesMoved:(id)moved withEvent:(id)event
{
	self.previousEvent = nil;
	
	invokeSupersequent(moved, event);
}

@end

@implementation UIPanGestureRecognizer (KIFOverridesInteral)

static NSString * const UIPanGestureRecognizerKIFOverridesInternalPreviousEventKey = @"previousEvent";
- (void)setPreviousEvent:(UIEvent *)previousEvent
{
	[self bnr_setAssociatedObject:previousEvent forKey:UIPanGestureRecognizerKIFOverridesInternalPreviousEventKey];
}
- (UIEvent *)previousEvent
{
	return [self bnr_associatedObjectForKey:UIPanGestureRecognizerKIFOverridesInternalPreviousEventKey];
}

@end

