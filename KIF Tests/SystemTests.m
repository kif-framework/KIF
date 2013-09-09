//
//  SystemTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface SystemTests : SenTestCase
@end

@implementation SystemTests

- (void)testWaitingForTimeInterval
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    [tester waitForTimeInterval:1.2];
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - startTime;
    STAssertTrue(elapsed > 1.2, @"Waiting should take the alotted time.");
    STAssertTrue(elapsed < 1.3, @"Waiting should not take too long.");
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
    STAssertEqualObjects(@"B", [notification.userInfo objectForKey:@"A"], @"Expected notification to match user data.");
}

- (void)testWaitingForNotificationWhileDoingOtherThings
{
    static NSString *const Name = @"Notification";
    id obj = [[NSObject alloc] init];
    
    NSNotification *notification = [system waitForNotificationName:Name object:obj whileExecutingBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:Name object:obj userInfo:@{@"A": @"B"}];
    }];
    
    STAssertEqualObjects(@"B", [notification.userInfo objectForKey:@"A"], @"Expected notification to match user data.");
}

- (void)testMemoryWarningSimulator
{
    [system waitForNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication] whileExecutingBlock:^{
        [system simulateMemoryWarning];
    }];
}

- (void)testMockingOpenURL
{
    __block BOOL returnValue;
    [system waitForApplicationToOpenURL:@"test123://" whileExecutingBlock:^{
        returnValue = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"test123://"]];
    } returning:NO];
    STAssertEquals(NO, returnValue, @"openURL: should have returned NO");
    
    [system waitForApplicationToOpenURL:@"test123://" whileExecutingBlock:^{
        returnValue = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"test123://"]];
    } returning:YES];
    STAssertEquals(YES, returnValue, @"openURL: should have returned YES");
    
    [system waitForApplicationToOpenAnyURLWhileExecutingBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"423543523454://"]];
    } returning:YES];
    
    STAssertFalse([[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"this-is-a-fake-url://"]], @"Should no longer be mocking, reject bad URL.");
}

@end
