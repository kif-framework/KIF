//
//  UIEvent+KIFAssociations.m
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import "UIEvent+KIFAssociations.h"
#import "NSObject+BNRAssociatedDictionary.h"

@implementation UIEvent (KIFAssociations)

static NSString * const UIEventKIFAssociationsKeyAssociatedTouches = @"kif_associatedTouches";
- (void)kif_setAssociatedTouches:(NSSet *)touches
{
	[self bnr_setAssociatedObject:touches forKey:UIEventKIFAssociationsKeyAssociatedTouches];
}
- (NSSet *)kif_associatedTouches
{
	return [self bnr_associatedObjectForKey:UIEventKIFAssociationsKeyAssociatedTouches];
}


- (void)kif_setAssociatedTouch:(UITouch *)touch
{
	[self kif_setAssociatedTouches:[NSSet setWithObject:touch]];
}
- (UITouch *)kif_associatedTouch
{
	return [[self kif_associatedTouches] anyObject];
}

@end
