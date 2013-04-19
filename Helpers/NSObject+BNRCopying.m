//
//  NSObject+BNRCopying.m
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import "NSObject+BNRCopying.h"
#import <objc/runtime.h>
#import "NSObject+BNRIvarConvenience.h"

@implementation NSObject (BNRCopying)

- (id)bnr_shallowCopy
{
	id res = [[self.class alloc] init];
	
	unsigned int count = 0;
	Ivar *ivars = class_copyIvarList(self.class, &count);
	NSSet *disallowedKeys = [NSSet setWithObjects:@"retainCount", nil];
	for (unsigned int i = 0; i < count; i++) {
		Ivar ivar = ivars[i];
		const char *name = ivar_getName(ivar);
		NSString *key = [NSString stringWithUTF8String:name];
		if (![disallowedKeys containsObject:key]) {
			void *bytesSource = [self bnr_ivarPointerForName:name];
			void *bytesTarget = [res bnr_ivarPointerForName:name];
			//We need to try here because of a bug with NSGetSizeAndAlignment
			//which prevents bitfields from being handled properly.
			//http://lists.apple.com/archives/cocoa-dev/2008/Sep/msg00883.html
			@try {
				NSUInteger size = 0;
				const char *encoding = ivar_getTypeEncoding(ivar);
				NSGetSizeAndAlignment(encoding, &size, NULL);
				if (size > 0) {
					if (strcmp(encoding, "@") == 0) {
						[(id)bytesSource retain];
					}
					memcpy(bytesTarget, bytesSource, size);
				} else {
					
				}
			}
			@catch (NSException *exception) {
			}
			@finally {
			}
		}
	}
	free(ivars);
	
	return res;
}

@end
