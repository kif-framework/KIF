//
//  AppDelegate.m
//  Test Suite
//
//  Created by Brian Nickel on 6/25/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

+ (instancetype) getAppDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) sendNotification:(NSString *)nString delay:(NSTimeInterval)delay userInfo:(id)userInfo
{
	void (^notificationBlock)(void) = ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:nString object:nil userInfo:userInfo];
	};

	if ((delay > 0) || (! [[NSThread currentThread] isMainThread])) {
		if (delay < 0) {
			delay = 0;
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			notificationBlock();
		});
	} else {
		notificationBlock();
	}
}

@end
