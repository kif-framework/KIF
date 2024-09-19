//
//  SystemTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

#define KIFAssertEqual XCTAssertEqual
#define KIFAssertEqualObjects XCTAssertEqualObjects
#define KIFAssertTrue XCTAssertTrue
#define KIFAssertFalse XCTAssertFalse

@interface SystemTests : XCTestCase

@end

@implementation SystemTests

- (void)testWaitingForTimeInterval
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    [tester waitForTimeInterval:1.2];
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - startTime;
    KIFAssertTrue(elapsed > 1.2, @"Waiting should take the allotted time.");
    KIFAssertTrue(elapsed < 1.3, @"Waiting should not take too long.");
}

- (void)testWaitingForNotification
{
    static NSString *const Name = @"Notification";
    id obj = [[NSObject alloc] init];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:Name object:obj userInfo:@{@"A": @"B"}];
    });
    
    NSNotification *notification = [system waitForNotificationName:Name object:obj];
    KIFAssertEqualObjects(@"B", [notification.userInfo objectForKey:@"A"], @"Expected notification to match user data.");
}

- (void)testWaitingForNotificationWhileDoingOtherThings
{
    static NSString *const Name = @"Notification";
    id obj = [[NSObject alloc] init];
    
    NSNotification *notification = [system waitForNotificationName:Name object:obj whileExecutingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Name object:obj userInfo:@{@"A": @"B"}];
    }];
    
    KIFAssertEqualObjects(@"B", [notification.userInfo objectForKey:@"A"], @"Expected notification to match user data.");
}

- (void)testMemoryWarningSimulator
{
    [system waitForNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication] whileExecutingBlock:^{
        [system simulateMemoryWarning];
    }];
}

- (void)testMockingOpenURL
{
    __block BOOL canOpenURLReturnValue;
    [system waitForApplicationToOpenURL:@"test123://" whileExecutingBlock:^{
        NSURL *uninstalledAppURL = [NSURL URLWithString:@"test123://"];
        canOpenURLReturnValue = [[UIApplication sharedApplication] canOpenURL:uninstalledAppURL];
        [[UIApplication sharedApplication] openURL:uninstalledAppURL options:[NSDictionary dictionary] completionHandler:nil];
    } returning:NO];
    KIFAssertEqual(NO, canOpenURLReturnValue, @"canOpenURL: should have returned NO");

    [system waitForApplicationToOpenURL:@"test123://" whileExecutingBlock:^{
        NSURL *installedAppURL = [NSURL URLWithString:@"test123://"];
        canOpenURLReturnValue = [[UIApplication sharedApplication] canOpenURL:installedAppURL];
        [[UIApplication sharedApplication] openURL:installedAppURL options:[NSDictionary dictionary] completionHandler:nil];
    } returning:YES];
    KIFAssertEqual(YES, canOpenURLReturnValue, @"canOpenURL: should have returned YES");

    [system waitForApplicationToOpenURLWithScheme:@"test123" whileExecutingBlock:^{
        NSURL *installedAppURL = [NSURL URLWithString:@"test123://some/path?query"];
        canOpenURLReturnValue = [[UIApplication sharedApplication] canOpenURL:installedAppURL];
        [[UIApplication sharedApplication] openURL:installedAppURL options:[NSDictionary dictionary] completionHandler:nil];
    } returning:YES];
    KIFAssertEqual(YES, canOpenURLReturnValue, @"canOpenURL: should have returned YES");

    [system waitForApplicationToOpenAnyURLWhileExecutingBlock:^{
        NSURL *someURL = [NSURL URLWithString:@"test12345://"];
        canOpenURLReturnValue = [[UIApplication sharedApplication] canOpenURL:someURL];
        [[UIApplication sharedApplication] openURL:someURL options:[NSDictionary dictionary] completionHandler:nil];
    } returning:YES];
    KIFAssertEqual(YES, canOpenURLReturnValue, @"canOpenURL: should have returned YES");

    NSURL *fakeURL = [NSURL URLWithString:@"this-is-a-fake-url://"];
    KIFAssertFalse([[UIApplication sharedApplication] canOpenURL:fakeURL], @"Should no longer be mocking, reject bad URL.");
}

@end
