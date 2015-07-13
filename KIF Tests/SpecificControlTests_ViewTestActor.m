//
//  NewSpecificControlTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>

@interface SpecificControlTests_ViewTestActor : KIFTestCase
@end

@implementation SpecificControlTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTogglingASwitch
{
    [[[[viewTester usingLabel:@"Happy"] usingValue:@"1"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingLabel:@"Happy"] setSwitchOn:NO];
    [[[[viewTester usingLabel:@"Happy"] usingValue:@"0"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingLabel:@"Happy"] setSwitchOn:YES];
    [[[[viewTester usingLabel:@"Happy"] usingValue:@"1"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testMovingASlider
{
    [viewTester waitForTimeInterval:1];
    [[viewTester usingLabel:@"Slider"] setSliderValue:3];
    [[[[viewTester usingLabel:@"Slider"] usingValue:@"3"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingLabel:@"Slider"] setSliderValue:0];
    [[[[viewTester usingLabel:@"Slider"] usingValue:@"0"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingLabel:@"Slider"] setSliderValue:5];
    [[[[viewTester usingLabel:@"Slider"] usingValue:@"5"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testPickingAPhoto
{
    [[viewTester usingLabel:@"Photos"] tap];
    [viewTester waitForTimeInterval:0.5f]; // Wait for view to stabilize
    [viewTester acknowledgeSystemAlert];
    [viewTester waitForTimeInterval:0.5f]; // Wait for view to stabilize

    NSString  *albumName = nil;

    NSOperatingSystemVersion iOS8 = {8, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        albumName = @"Camera Roll";
    } else {
        albumName = @"Saved Photos";
    }
    [viewTester choosePhotoInAlbum:albumName atRow:1 column:2];
    [[viewTester usingLabel:albumName] waitForAbsenceOfView];
    
}

@end
