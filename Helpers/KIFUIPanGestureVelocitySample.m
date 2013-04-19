//
//  KIFUIPanGestureVelocitySample.m
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import "KIFUIPanGestureVelocitySample.h"

@implementation KIFUIPanGestureVelocitySample
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p| %f: %@->%@>", self.class, self, self.dt, NSStringFromCGPoint(self.start), NSStringFromCGPoint(self.end)];
}
+ (NSArray *)sharedKeys
{
	return @[@"dt", @"end", @"start"];
}
- (id)initWithPanGestureVelocitySample:(id)panGestureVelocitySample
{
	self = [super init];
	if (self) {
		for (NSString *key in self.class.sharedKeys) {
			[self setValue:[panGestureVelocitySample valueForKey:key] forKey:key];
		}
	}
	return self;
}
- (id)panGestureVelocitySample
{
	id value = NSAllocateObject(NSClassFromString(@"UIPanGestureVelocitySample"), 0, nil);
	for (NSString *key in self.class.sharedKeys) {
		[value setValue:[self valueForKey:key] forKey:key];
	}
	return value;
}
@end
