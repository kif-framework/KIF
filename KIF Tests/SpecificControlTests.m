//
//  SpecificControlTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface SpecificControlTests : KIFTestCase
@end

@implementation SpecificControlTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testTogglingASwitch
{
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone];
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"Happy"];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"0" traits:UIAccessibilityTraitNone];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Happy"];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone];
}

- (void)testMovingASlider
{
    [tester waitForTimeInterval:1];
    [tester setValue:3 forSliderWithAccessibilityLabel:@"Slider"];
    [tester waitForViewWithAccessibilityLabel:@"Slider" value:@"3" traits:UIAccessibilityTraitNone];
}

- (void)testReturningFromATextField
{
    [tester tapViewWithAccessibilityLabel:@"Greeting"];
    [tester waitForTimeInterval:1];
    [tester tapViewWithAccessibilityLabel:@"return"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"return"];
}

/*
 TODO: Should we implement this test?  It is really domain specific. It depends on a UI element named "Choose Photo" which is wired to create an image picker, an album with a matching name, and photos to be on the device.
 + (NSArray *)stepsToChoosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
 */

@end
