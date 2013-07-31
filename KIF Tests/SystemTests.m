//
//  SystemTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface SystemTests : KIFTestCase
@end

@implementation SystemTests

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testWaitingForTimeInterval
{
    [tester tapViewWithAccessibilityLabel:@"Show/Hide"];
    
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    [tester waitForTimeInterval:1.2];
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - startTime;
    STAssertTrue(elapsed > 1.2, @"Waiting should take the alotted time.");
    STAssertTrue(elapsed < 1.3, @"Waiting should not take too long.");
}

- (void)testWaitingForNotification
{
    [tester tapViewWithAccessibilityLabel:@"Show/Hide"];
    [tester tapViewWithAccessibilityLabel:@"Delayed Show/Hide"];
    [system waitForNotificationName:@"DelayedShowHide" object:[UIApplication sharedApplication]];
}

- (void)testWaitingForNotificationWhileDoingOtherThings
{
    [tester tapViewWithAccessibilityLabel:@"Show/Hide"];
    [system waitForNotificationName:@"InstantShowHide" object:[UIApplication sharedApplication] whileExecutingBlock:^{
        [tester tapViewWithAccessibilityLabel:@"Instant Show/Hide"];
    }];
}

- (void)testMemoryWarningSimulator
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
    [tester tapViewWithAccessibilityLabel:@"Hide memory warning"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Memory Critical"];
    [system simulateMemoryWarning];
    [tester waitForViewWithAccessibilityLabel:@"Memory Critical"];
}

@end
