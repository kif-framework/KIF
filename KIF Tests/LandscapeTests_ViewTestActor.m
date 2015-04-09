//
//  NewLandscapeTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>

@interface LandscapeTests_ViewTestActor : KIFTestCase
@end

@implementation LandscapeTests_ViewTestActor

- (void)beforeAll
{
    [system simulateDeviceRotationToOrientation:UIDeviceOrientationLandscapeLeft];
    [[viewTester usingAccessibilityIdentifier:@"Test Suite TableView"] scrollByFractionOfSizeHorizontal:0 vertical:-0.2];
}

- (void)afterAll
{
    [system simulateDeviceRotationToOrientation:UIDeviceOrientationPortrait];
    [viewTester waitForTimeInterval:0.5];
}

- (void)beforeEach
{
    [viewTester waitForTimeInterval:0.25];
}

- (void)testThatAlertViewsCanBeTappedInLandscape
{
    [[viewTester usingAccessibilityLabel:@"UIAlertView"] tap];
    [[viewTester usingAccessibilityLabel:@"Continue"] tap];
    [[viewTester usingAccessibilityLabel:@"Message"] waitForAbsenceOfView];
}

@end
