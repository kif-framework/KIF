//
//  KIFElement+Private.h
//  Temperature
//
//  Created by Josh Abernathy on 7/16/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFElement.h"


@interface KIFElement (Private)

- (CFTypeRef)attributeForKey:(NSString *)key;
- (id)wrappedAttributeForKey:(NSString *)key;

@end
