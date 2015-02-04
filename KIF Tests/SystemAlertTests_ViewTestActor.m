//
//  NewSystemAlertTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@interface SystemAlertTests_ViewTestActor : KIFTestCase
@end


@implementation SystemAlertTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"System Alerts"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testAuthorizingLocationServices
{
    [[viewTester usingAccessibilityLabel:@"Location Services"] tap];
    [viewTester acknowledgeSystemAlert];
}

- (void)testAuthorizingPhotosAccess
{
    [[viewTester usingAccessibilityLabel:@"Photos"] tap];
    [viewTester acknowledgeSystemAlert];
    [[viewTester usingAccessibilityLabel:@"Cancel"] tap];
}

- (void)testNotificationScheduling
{
    [[viewTester usingAccessibilityLabel:@"Notifications"] tap];
    [viewTester acknowledgeSystemAlert];
}

@end
