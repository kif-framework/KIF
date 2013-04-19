//
//  UIPanGestureRecognizer+KIFExposers.m
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import "UIPanGestureRecognizer+KIFExposers.h"
#import "KIFUIPanGestureVelocitySample.h"

@implementation UIPanGestureRecognizer (KIFExposers)

static NSString * const UIPanGestureVelocitySampleKIFExposerKeyVelocitySample = @"_velocitySample";
- (KIFUIPanGestureVelocitySample *)velocitySample
{
	return [[[KIFUIPanGestureVelocitySample alloc] initWithPanGestureVelocitySample:[self valueForKey:UIPanGestureVelocitySampleKIFExposerKeyVelocitySample]] autorelease];
}
- (void)setVelocitySample:(KIFUIPanGestureVelocitySample *)velocitySample
{
	[self setValue:velocitySample.panGestureVelocitySample forKey:UIPanGestureVelocitySampleKIFExposerKeyVelocitySample];
}

static NSString * const UIPanGestureVelocitySampleKIFExposerKeyPreviousVelocitySample = @"_previousVelocitySample";
- (KIFUIPanGestureVelocitySample *)previousVelocitySample
{
	return [self valueForKey:UIPanGestureVelocitySampleKIFExposerKeyPreviousVelocitySample];
}
- (void)setPreviousVelocitySample:(KIFUIPanGestureVelocitySample *)previousVelocitySample
{
	[self setValue:previousVelocitySample forKey:UIPanGestureVelocitySampleKIFExposerKeyPreviousVelocitySample];
}

@end
