//
//  UITouch+KIFExposers.m
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import "UITouch+KIFExposers.h"

@implementation UITouch (KIFExposers)

static NSString * const UITouchKIFExposersLocationInWindowKey = @"_locationInWindow";
- (CGPoint)kif_locationInWindow
{
	NSValue *value = [self valueForKey:UITouchKIFExposersLocationInWindowKey];
	CGPoint point = CGPointZero;
	[value getValue:&point];
	return point;
}
- (void)kif_setLocationInWindow:(CGPoint)point
{
	NSValue *value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
	[self setValue:value forKey:UITouchKIFExposersLocationInWindowKey];
}

static NSString * const UITouchKIFExposersPreviousLocationInWindowKey = @"_previousLocationInWindow";
- (CGPoint)kif_previousLocationInWindow
{
	NSValue *value = [self valueForKey:UITouchKIFExposersPreviousLocationInWindowKey];
	CGPoint point = CGPointZero;
	[value getValue:&point];
	return point;
}
- (void)kif_setPreviousLocationInWindow:(CGPoint)point
{
	NSValue *value = [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
	[self setValue:value forKey:UITouchKIFExposersPreviousLocationInWindowKey];
}

@end
