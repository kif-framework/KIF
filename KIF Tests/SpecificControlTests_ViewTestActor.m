//
//  NewSpecificControlTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>

@implementation KIFUIViewTestActor (specifiControlTests)

- (instancetype)happySwitch;
{
    return [viewTester usingAccessibilityLabel:@"Happy"];
}

- (instancetype)slider;
{
    return [viewTester usingAccessibilityLabel:@"Slider"];
}
@end

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
    [[[viewTester happySwitch] usingValue:@"1"] waitForView];
    [[viewTester happySwitch] setSwitchOn:NO];
    [[[viewTester happySwitch] usingValue:@"0"] waitForView];
    [[viewTester happySwitch] setSwitchOn:YES];
    [[[viewTester happySwitch] usingValue:@"1"] waitForView];
}

- (void)testMovingASlider
{
    [viewTester waitForTimeInterval:1];
    [[viewTester slider] setSliderValue:3];
    [[[viewTester slider] usingValue:@"3"] waitForView];
    [[viewTester slider] setSliderValue:0];
    [[[viewTester slider] usingValue:@"0"] waitForView];
    [[viewTester slider] setSliderValue:5];
    [[[viewTester slider] usingValue:@"5"] waitForView];
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
