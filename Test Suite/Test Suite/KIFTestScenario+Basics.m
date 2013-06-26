//
//  KIFTestScenario+Basics.m
//  Test Suite
//
//  Created by Brian Nickel on 6/25/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "../../Classes/KIFTestScenario.h"
#import "../../Classes/KIFTestStep.h"

@interface KIFTestScenario (Basics)
@end

@implementation KIFTestScenario (Basics)

+ (NSArray *)stepsToTearDown
{
    return @[[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton]];
}

+ (instancetype)scenarioToTestWaitingForViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Test Suite"]];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForViewWithTraits
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for view with accessibility label and traits."];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitStaticText]];
    return scenario;
}

/* 
 + (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
 */


+ (instancetype)scenarioToTestWaitingForAbscenseOfViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for abscence of view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Test Suite 2.0 Platinum"]];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForAbscenseOfViewWithTraits
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for abscence of view with accessibility label and traits."];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitSearchField]];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForAbscenseOfViewWithValue
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for abscence of view with accessibility label and traits."];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Test Suite" value:@"100" traits:UIAccessibilityTraitNone]];
    return scenario;
}

/*
 
 + (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label;
 + (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
 + (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
 + (id)stepToWaitForTimeInterval:(NSTimeInterval)interval description:(NSString *)description;
 + (id)stepToWaitForNotificationName:(NSString*)name object:(id)object;
 + (id)stepToWaitForNotificationName:(NSString *)name object:(id)object whileExecutingStep:(KIFTestStep *)childStep;
 */

+ (instancetype)scenarioToTestTappingViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Tap view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"TapViewController"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestTappingViewWithTraits
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Tap view with traits."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Second" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Second" traits:UIAccessibilityTraitButton | UIAccessibilityTraitSelected]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}


+ (instancetype)scenarioToTestTappingViewWithValue
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Tap view with value."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Greeting" value:@"Hello" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"return"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

/*
 + (id)stepToTapScreenAtPoint:(CGPoint)screenPoint;
 */

+ (instancetype)scenarioToTestLongPressingViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Long press view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Greeting" duration:2]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Select All"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestLongPressingViewWithValue
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Long press view with value."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Greeting" value:@"Hello" duration:2]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Select All"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

/*
+ (instancetype)scenarioToTestLongPressingViewWithTraits
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Long press view with traits."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Greeting" value:@"Hello" traits:UIAccessibilityTraitUpdatesFrequently duration:2]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Select All"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}
 */

+ (instancetype)scenarioToEnterTextIntoFirstReponder
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Enter text into first responder."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Greeting" duration:2]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Select All"]];
    [scenario addStep:[KIFTestStep stepToEnterTextIntoCurrentFirstResponder:@"Yo"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Greeting" value:@"Yo" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToEnterTextIntoViewWithAccessibilityLabelExpectingResults
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Enter text into first responder."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@", world" intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"Hello, world"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Greeting" value:@"Hello, world" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToEnterTextIntoViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Enter text into first responder."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Greeting" duration:2]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Select All"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delete"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Yo" intoViewWithAccessibilityLabel:@"Greeting"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Greeting" value:@"Yo" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

/*
 + (id)stepToSelectPickerViewRowWithTitle:(NSString *)title;
 */

+ (instancetype)scenarioToTestSwitches
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Switches"];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToSetOn:NO forSwitchWithAccessibilityLabel:@"Happy"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Happy" value:@"0" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToSetOn:YES forSwitchWithAccessibilityLabel:@"Happy"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}
/*
 + (id)stepToDismissPopover;
 */

+ (instancetype)scenarioToTestMemoryWarningSimulator
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Simulate memory warning"];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Hide memory warning"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Memory Critical"]];
    [scenario addStep:[KIFTestStep stepToSimulateMemoryWarning]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Memory Critical"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

/*
 + (NSArray *)stepsToChoosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
 */

+ (instancetype)scenarioToTestTappingRows
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Simulate memory warning"];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Find Me" traits:UIAccessibilityTraitSelected]];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestSwiping
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Simulate memory warning"];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Happy" inDirection:KIFSwipeDirectionLeft]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Happy" value:@"0" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Happy" inDirection:KIFSwipeDirectionRight]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestScrolling
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Simulate memory warning"];
    [scenario addStep:[KIFTestStep stepToScrollViewWithAccessibilityLabel:@"Middle" byFractionOfSizeHorizontal:0 vertical:-1]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToScrollViewWithAccessibilityLabel:@"Middle" byFractionOfSizeHorizontal:0 vertical:1]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Tapping"]];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForFirstResponder
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for first responder"];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Greeting" value:@"Hello" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToWaitForFirstResponderWithAccessibilityLabel:@"Greeting"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

@end
