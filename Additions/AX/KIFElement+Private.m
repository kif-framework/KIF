//
//  KIFElement+Private.m
//  Temperature
//
//  Created by Josh Abernathy on 7/16/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "KIFElement+Private.h"


@implementation KIFElement (Private)


#pragma mark API

- (CFTypeRef)attributeForKey:(NSString *)key {
	CFTypeRef value = NULL;
	AXUIElementCopyAttributeValue(self.elementRef, (CFStringRef) key, &value);
	return [(id) value autorelease];
}

- (id)wrappedAttributeForKey:(NSString *)key {
	CFTypeRef result = [self attributeForKey:key];
	if(result == NULL) return nil;
	
	if([(id) result isKindOfClass:[NSArray class]]) {
		NSArray *resultArray = (id) result;
		NSMutableArray *results = [NSMutableArray arrayWithCapacity:resultArray.count];
		for(id ref in resultArray) {
			[results addObject:[KIFElement elementWithElementRef:(AXUIElementRef) ref]];
		}
		
		return [[results copy] autorelease];
	} else {
		KIFElement *element = [KIFElement elementWithElementRef:result];
		return element;
	}
}

@end
