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
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
    [tester tapViewWithAccessibilityLabel:@"X"];
    [tester tapViewWithAccessibilityLabel:@"X"];
    [tester waitForViewWithAccessibilityLabel:@"Slider" value:@"40%" traits:UIAccessibilityTraitNone];
    [tester waitForTimeInterval:3]; // Value is resetting.
    [tester tapViewWithAccessibilityLabel:@"X"];
    [tester tapViewWithAccessibilityLabel:@"X"];
    [tester tapViewWithAccessibilityLabel:@"X"];
    [tester waitForViewWithAccessibilityLabel:@"Slider" value:@"60%" traits:UIAccessibilityTraitNone];
}

- (void)testWaitingForNotification
{
    [tester tapViewWithAccessibilityLabel:@"Show/Hide"];
    [tester tapViewWithAccessibilityLabel:@"Delayed Show/Hide"];
    [tester waitForNotificationName:@"DelayedShowHide" object:[UIApplication sharedApplication]];
}

- (void)testWaitingForNotificationWhileDoingOtherThings
{
    [tester tapViewWithAccessibilityLabel:@"Show/Hide"];
    [tester waitForNotificationName:@"InstantShowHide" object:[UIApplication sharedApplication] whileExecutingBlock:^{
        [tester tapViewWithAccessibilityLabel:@"Instant Show/Hide"];
    }];
}

- (void)testMemoryWarningSimulator
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
    [tester tapViewWithAccessibilityLabel:@"Hide memory warning"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Memory Critical"];
    [tester simulateMemoryWarning];
    [tester waitForViewWithAccessibilityLabel:@"Memory Critical"];
}

@end
