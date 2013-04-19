//
//  NSObject+MGSupersequentImplementation.h
//  Uverse Mobile
//
//  Created by Nate Chandler on 3/22/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MGSupersequentImplementation)
- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip;
@end

extern IMP impOfCallingMethod(id lookupObject, SEL selector);

#define invokeSupersequent(...) \
	([self getImplementationOf:_cmd \
	after:impOfCallingMethod(self, _cmd)]) \
	(self, _cmd, ##__VA_ARGS__)

#define invokeSupersequentNoParameters() \
	([self getImplementationOf:_cmd \
	after:impOfCallingMethod(self, _cmd)]) \
	(self, _cmd)