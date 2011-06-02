//
//  UITouchEvent-KIFExposure.m
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "UITouchEvent-KIFExposure.h"


//
// GSEvent is an undeclared object. We don't need to use it ourselves but some
// Apple APIs (UIScrollView in particular) require the x and y fields to be present.
//
@interface KIFEventProxy : NSObject
{
@public
	unsigned int flags;
	unsigned int type;
	unsigned int ignored1;
	float x1;
	float y1;
	float x2;
	float y2;
	unsigned int ignored2[10];
	unsigned int ignored3[7];
	float sizeX;
	float sizeY;
	float x3;
	float y3;
	unsigned int ignored4[3];
}

@end

@implementation KIFEventProxy
@end


@interface UIEvent (Private)

- (id)_initWithEvent:(KIFEventProxy *)fp8 touches:(id)fp12;

@end


@implementation UIEvent (Synthesize)

- (id)initWithTouch:(UITouch *)touch
{
	CGPoint location = [touch locationInView:touch.window];
	KIFEventProxy *eventProxy = [[KIFEventProxy alloc] init];
	eventProxy->x1 = location.x;
	eventProxy->y1 = location.y;
	eventProxy->x2 = location.x;
	eventProxy->y2 = location.y;
	eventProxy->x3 = location.x;
	eventProxy->y3 = location.y;
	eventProxy->sizeX = 1.0;
	eventProxy->sizeY = 1.0;
	eventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
	eventProxy->type = 3001;	
	
	//
	// On SDK versions 3.0 and greater, we need to reallocate as a
	// UITouchesEvent.
	//
	Class touchesEventClass = objc_getClass("UITouchesEvent");
	if (touchesEventClass && ![[self class] isEqual:touchesEventClass])
	{
		[self release];
		self = [touchesEventClass alloc];
	}
	
	return [(UIEvent *)self _initWithEvent:eventProxy touches:[NSMutableSet setWithObject:touch]];
}

@end
