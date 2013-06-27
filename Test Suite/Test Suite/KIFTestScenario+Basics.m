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
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for view with traits."];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitStaticText]];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForViewWithValue
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for view with value."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Slider" value:@"0%" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForAbscenseOfViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for abscence of view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delayed Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Content"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Content"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForAbscenseOfViewWithTraits
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for abscence of view with traits."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delayed Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Content" traits:UIAccessibilityTraitUpdatesFrequently]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Content" traits:UIAccessibilityTraitUpdatesFrequently]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForAbscenseOfViewWithValue
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for abscence of view with value."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delayed Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Content" value:@"Value" traits:UIAccessibilityTraitUpdatesFrequently]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Content" value:@"Value" traits:UIAccessibilityTraitUpdatesFrequently]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForTappableViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for tappable view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cover/Uncover"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"B"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForTappableViewWithTraits
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for tappable view with traits."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cover/Uncover"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"B" traits:UIAccessibilityTraitButton]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForTappableViewWithValue
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for tappable view with value."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cover/Uncover"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"B" value:@"BB" traits:UIAccessibilityTraitButton]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForTimeInterval
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Tap view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"X"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"X"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Slider" value:@"40%" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:3 description:@"Waiting for value to reset."]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"X"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"X"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"X"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Slider" value:@"60%" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForNotification
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for notification."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delayed Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToWaitForNotificationName:@"DelayedShowHide" object:[UIApplication sharedApplication]]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestWaitingForNotificationWhileExecutingStep
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Wait for notification while executing step."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Show/Hide"]];
    [scenario addStep:[KIFTestStep stepToWaitForNotificationName:@"InstantShowHide" object:[UIApplication sharedApplication] whileExecutingStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Instant Show/Hide"]]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

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

+ (instancetype)scenarioToTestTappingScreenAtPoint
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Tap view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:0.75 description:@"Waiting for navigation to complete."]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(15, 200)]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"X" traits:UIAccessibilityTraitSelected]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

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

+ (instancetype)scenarioToTestLongPressingViewWithTraits
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Long press view with traits."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Greeting" value:@"Hello" traits:UIAccessibilityTraitUpdatesFrequently duration:2]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Select All"]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

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
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Enter text into view with accessibility label, expecting results."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@", world" intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"Hello, world"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Greeting" value:@"Hello, world" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToEnterTextIntoViewWithAccessibilityLabel
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Enter text into view with accessibility label."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Greeting" duration:2]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Select All"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Delete"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Yo" intoViewWithAccessibilityLabel:@"Greeting"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Greeting" value:@"Yo" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToSelectAPickerRow
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Select a picker row."];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToSelectPickerViewRowWithTitle:@"Charlie"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Call Sign" value:@"Charlie. 3 of 3" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

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
 TODO: Add support for testing this iPad-only feature.
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
 TODO: Should we implement this test?  It is really domain specific. It depends on a UI element named "Choose Photo" which is wired to create an image picker, an album with a matching name, and photos to be on the device.
 + (NSArray *)stepsToChoosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
 */

+ (instancetype)scenarioToTestTappingRows
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Tapping rows"];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Find Me" traits:UIAccessibilityTraitSelected]];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestSwiping
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Swiping"];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tapping"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Happy" inDirection:KIFSwipeDirectionLeft]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Happy" value:@"0" traits:UIAccessibilityTraitNone]];
    scenario.stepsToTearDown = [self stepsToTearDown];
    return scenario;
}

+ (instancetype)scenarioToTestScrolling
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Scrolling"];
    [scenario addStep:[KIFTestStep stepToScrollViewWithAccessibilityLabel:@"Table View" byFractionOfSizeHorizontal:0 vertical:-0.9]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Find Me"]];
    [scenario addStep:[KIFTestStep stepToScrollViewWithAccessibilityLabel:@"Table View" byFractionOfSizeHorizontal:0 vertical:0.9]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Tapping"]];
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
