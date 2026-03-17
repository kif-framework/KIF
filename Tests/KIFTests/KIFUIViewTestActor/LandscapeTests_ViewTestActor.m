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
    [viewTester waitForAnimationsToFinish];
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
    [viewTester tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [[viewTester usingLabel:@"Cancel"] tap];
    } else {
        /* On iPadOS the UIAlertController is displayed as a popup over table view cell, there's no "Cancel" button.
         It can be dismissed by tapping anywhere on the screen.
         */
        [viewTester tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    }
    [[viewTester usingLabel:@"Continue"] tap];
    [[viewTester usingLabel:@"Message"] waitForAbsenceOfView];
}

@end
