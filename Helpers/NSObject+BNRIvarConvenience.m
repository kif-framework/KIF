//
//  NSObject+BNRIvarConvenience.m
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import "NSObject+BNRIvarConvenience.h"
#import <objc/runtime.h>

@implementation NSObject (BNRIvarConvenience)

//modified from http://stackoverflow.com/a/12265664/1052673
- (void *)bnr_ivarPointerForName:(const char *)name
{
	void *res = NULL;
	
	Ivar ivar = class_getInstanceVariable(self.class, name);
	
    if (ivar) {
		res = (void *)self + ivar_getOffset(ivar);
	}
	
	return res;
}

@end