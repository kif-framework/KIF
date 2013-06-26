//
//  AppDelegate.m
//  Test Suite
//
//  Created by Brian Nickel on 6/25/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "AppDelegate.h"
#import "../../Classes/KIFTestController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[KIFTestController sharedInstance] startTestingWithCompletionBlock:^{
    }];
    return YES;
}

@end
