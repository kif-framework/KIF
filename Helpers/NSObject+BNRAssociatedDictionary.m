//
//  NSObject+BNRAssociatedDictionary.m
//  KIF
//
//  Created by Nate Chandler on 3/27/13.
//
//

#import "NSObject+BNRAssociatedDictionary.h"
#import <objc/runtime.h>

@implementation NSObject (BNRAssociatedDictionary)

static char NSObjectADDLAssociatedDictionaryAssociatedDictionaryAssociatedObjectKey = 0;

- (NSMutableDictionary *)bnr_associatedDictionaryPrimitive
{
	return objc_getAssociatedObject(self, &NSObjectADDLAssociatedDictionaryAssociatedDictionaryAssociatedObjectKey);
}

- (void)bnr_setAssociatedDictionaryPrimitive:(NSMutableDictionary *)associatedDictionary
{
	objc_setAssociatedObject(self, &NSObjectADDLAssociatedDictionaryAssociatedDictionaryAssociatedObjectKey, associatedDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)bnr_generateAssociatedDictionary
{
	NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
	[self bnr_setAssociatedDictionaryPrimitive:res];
	return [res autorelease];
}

- (NSMutableDictionary *)bnr_associatedDictionary
{
	NSMutableDictionary *res = [self bnr_associatedDictionaryPrimitive];
	if (!res) {
		res = [self bnr_generateAssociatedDictionary];
	}
	return res;
}

- (id)bnr_associatedObjectForKey:(id<NSCopying>)key
{
	return self.bnr_associatedDictionary[key];
}

- (void)bnr_setAssociatedObject:(id)object forKey:(id<NSCopying>)key
{
	if (object) {
		self.bnr_associatedDictionary[key] = object;
	} else {
		[self.bnr_associatedDictionary removeObjectForKey:key];
	}
}

@end
