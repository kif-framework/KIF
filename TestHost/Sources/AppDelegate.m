//
//  AppDelegate.m
//  Test Suite
//
//  Created by Brian Nickel on 6/25/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *testSuiteViewController = [[NSClassFromString(@"TestSuiteViewController") alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.viewControllers = @[testSuiteViewController];
    navigationController.toolbarHidden = NO;
    navigationController.navigationBar.translucent = NO;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Speed up animations to improve test times
    self.window.layer.speed = 3;
}

@end
