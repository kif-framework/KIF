//
//  LandscapeTests.m
//  KIF
//
//  Created by Brian Nickel on 9/11/13.
//
//

@import KIF;

@interface LandscapeTests : KIFTestCase
@end

@implementation LandscapeTests

- (void)beforeAll
{
    [system simulateDeviceRotationToOrientation:UIDeviceOrientationLandscapeLeft];
    [tester waitForAnimationsToFinish];

    [tester scrollViewWithAccessibilityIdentifier:@"Test Suite TableView" byFractionOfSizeHorizontal:0 vertical:-0.2];

    [tester waitForAnimationsToFinish];
}

- (void)afterAll
{
    [system simulateDeviceRotationToOrientation:UIDeviceOrientationPortrait];
    [tester waitForTimeInterval:0.5];
}

- (void)testThatAlertViewsCanBeTappedInLandscape
{
    // The tap can fail if the initial scroll is still happening scroll
    [tester waitForTimeInterval:1.0];
    [tester tapViewWithAccessibilityLabel:@"UIAlertController"];
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [tester tapViewWithAccessibilityLabel:@"Cancel"];
    } else {
        /* On iPadOS the UIAlertController is displayed as a popup over table view cell, there's no "Cancel" button.
         It can be dismissed by tapping anywhere on the screen.
         */
        [tester tapScreenAtPoint:CGPointMake(1, 1)];
    }
    [tester tapViewWithAccessibilityLabel:@"Continue"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Alert View"];
}

@end
