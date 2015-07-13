//
//  NewSystemAlertTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@interface AcknowledgeSystemAlertTests_ViewTestActor : KIFTestCase
@end


@implementation AcknowledgeSystemAlertTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"System Alerts"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testAuthorizingLocationServices
{
    [[viewTester usingLabel:@"Location Services"] tap];
    [viewTester acknowledgeSystemAlert];
}

- (void)testAuthorizingPhotosAccess
{
    [[viewTester usingLabel:@"Photos"] tap];
    [viewTester acknowledgeSystemAlert];
    [[viewTester usingLabel:@"Cancel"] tap];
}

- (void)testNotificationScheduling
{
    [[viewTester usingLabel:@"Notifications"] tap];
    [viewTester acknowledgeSystemAlert];
}

@end
