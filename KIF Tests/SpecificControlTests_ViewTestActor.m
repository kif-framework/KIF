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
    [[[viewTester usingAccessibilityLabel:@"Happy"] usingValue:@"1"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Happy"] setSwitchOn:NO];
    [[[viewTester usingAccessibilityLabel:@"Happy"] usingValue:@"0"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Happy"] setSwitchOn:YES];
    [[[viewTester usingAccessibilityLabel:@"Happy"] usingValue:@"1"] waitForView];
}

- (void)testMovingASlider
{
    [viewTester waitForTimeInterval:1];
    [[viewTester usingAccessibilityLabel:@"Slider"] setSliderValue:3];
    [[[viewTester usingAccessibilityLabel:@"Slider"] usingValue:@"3"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Slider"] setSliderValue:0];
    [[[viewTester usingAccessibilityLabel:@"Slider"] usingValue:@"0"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Slider"] setSliderValue:5];
    [[[viewTester usingAccessibilityLabel:@"Slider"] usingValue:@"5"] waitForView];
}

// Temporarily disabling this test until we figure out why it is failing in Square's CI system
- (void)DISABLED_testPickingAPhoto
{
    // 'acknowledgeSystemAlert' can't be used on iOS7
    // The console shows a message "AX Lookup problem! 22 com.apple.iphone.axserver:-1"
    if ([UIDevice.currentDevice.systemVersion compare:@"8.0" options:NSNumericSearch] < 0) {
        return;
    }
    
    [[viewTester usingAccessibilityLabel:@"Photos"] tap];
    [viewTester acknowledgeSystemAlert];
    [viewTester waitForTimeInterval:0.5f]; // Wait for view to stabilize
    
    [viewTester choosePhotoInAlbum:@"Camera Roll" atRow:1 column:2];
    [[viewTester usingAccessibilityLabel:@"UIImage"] waitForView];
}

@end
