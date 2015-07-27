//
//  NewPickerTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>

@interface PickerTests_ViewTestActor : KIFTestCase
@end

@implementation PickerTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Pickers"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testSelectingDateInPast
{
    [[viewTester usingLabel:@"Date Selection"] tap];
    NSArray *date = @[ @"June", @"17", @"1965" ];
    // If the UIDatePicker LocaleIdentifier would be de_DE then the date to set
    // would look like this: NSArray *date = @[@"17.", @"Juni", @"1965"
    [viewTester selectDatePickerValue:date];
    [[[[viewTester usingLabel:@"Date Selection"] usingValue:@"Jun 17, 1965"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testSelectingDateInFuture
{
    [[viewTester usingLabel:@"Date Selection"] tap];
    NSArray *date = @[ @"December", @"31", @"2030" ];
    [viewTester selectDatePickerValue:date];
    [[[[viewTester usingLabel:@"Date Selection"] usingValue:@"Dec 31, 2030"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testSelectingDateTime
{
    [[viewTester usingLabel:@"Date Time Selection"] tap];
    NSArray *dateTime = @[ @"Jun 17", @"6", @"43", @"AM" ];
    [viewTester selectDatePickerValue:dateTime];
    [[[[viewTester usingLabel:@"Date Time Selection"] usingValue:@"Jun 17, 06:43 AM"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testSelectingTime
{
    [[viewTester usingLabel:@"Time Selection"] tap];
    NSArray *time = @[ @"7", @"44", @"AM" ];
    [viewTester selectDatePickerValue:time];
    [[[[viewTester usingLabel:@"Time Selection"] usingValue:@"7:44 AM"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testSelectingCountdown
{
    [[viewTester usingLabel:@"Countdown Selection"] tap];
    NSArray *countdown = @[ @"4", @"10" ];
    [viewTester selectDatePickerValue:countdown];
    [[[[viewTester usingLabel:@"Countdown Selection"] usingValue:@"15000.000000"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testSelectingAPickerRow
{
    [viewTester selectPickerViewRowWithTitle:@"Charlie"];

    NSOperatingSystemVersion iOS8 = {8, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [[[[viewTester usingLabel:@"Call Sign"] usingValue:@"Charlie"] usingTraits:UIAccessibilityTraitNone] waitForView];
    } else {
        [[[[viewTester usingLabel:@"Call Sign"] usingValue:@"Charlie. 3 of 3"] usingTraits:UIAccessibilityTraitNone] waitForView];
    }
}

- (void)testSelectingRowInComponent
{
    [[viewTester usingLabel:@"Date Selection"] tap];
    NSArray *date = @[ @"December", @"31", @"2030" ];
    [viewTester selectDatePickerValue:date];
    [viewTester selectPickerViewRowWithTitle:@"17" inComponent:1];
    [[[[viewTester usingLabel:@"Date Selection"] usingValue:@"Dec 17, 2030"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

@end
