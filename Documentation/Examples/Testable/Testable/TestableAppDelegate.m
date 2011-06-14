//
//  TestableAppDelegate.m
//  Testable
//
//  Created by Eric Firestone on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestableAppDelegate.h"
#import "EXTestController.h"


@implementation TestableAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
#if RUN_KIF_TESTS
    [[EXTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete. When running on CI, this lets you check the return value for pass/fail.
        exit([[EXTestController sharedInstance] failureCount]);
    }];
#endif
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
