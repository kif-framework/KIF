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
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTogglingASwitch
{
    [[[[viewTester usingAccessibilityLabel:@"Happy"] usingValue:@"1"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingAccessibilityLabel:@"Happy"] setSwitchOn:NO];
    [[[[viewTester usingAccessibilityLabel:@"Happy"] usingValue:@"0"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingAccessibilityLabel:@"Happy"] setSwitchOn:YES];
    [[[[viewTester usingAccessibilityLabel:@"Happy"] usingValue:@"1"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testMovingASlider
{
    [viewTester waitForTimeInterval:1];
    [[viewTester usingAccessibilityLabel:@"Slider"] setSliderValue:3];
    [[[[viewTester usingAccessibilityLabel:@"Slider"] usingValue:@"3"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingAccessibilityLabel:@"Slider"] setSliderValue:0];
    [[[[viewTester usingAccessibilityLabel:@"Slider"] usingValue:@"0"] usingTraits:UIAccessibilityTraitNone] waitForView];
    [[viewTester usingAccessibilityLabel:@"Slider"] setSliderValue:5];
    [[[[viewTester usingAccessibilityLabel:@"Slider"] usingValue:@"5"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testPickingAPhoto
{
    [[viewTester usingAccessibilityLabel:@"Photos"] tap];
    [viewTester acknowledgeSystemAlert];
    [viewTester waitForTimeInterval:0.5f]; // Wait for view to stabilize

    NSOperatingSystemVersion iOS8 = {8, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [viewTester choosePhotoInAlbum:@"Camera Roll" atRow:1 column:2];
    } else {
        [viewTester choosePhotoInAlbum:@"Saved Photos" atRow:1 column:2];
    }
    [[viewTester usingAccessibilityLabel:@"{834, 1250}"] waitForView];
}

@end
