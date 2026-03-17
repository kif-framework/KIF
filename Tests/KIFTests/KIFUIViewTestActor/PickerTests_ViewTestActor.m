//
//  NewPickerTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>

@implementation KIFUIViewTestActor (pickertests)

- (KIFUIViewTestActor *)dateSelector
{
    return [self usingLabel:@"Date Selection"];
}

- (KIFUIViewTestActor *)dateTimeSelector
{
    return [self usingLabel:@"Date Time Selection"];
}

- (KIFUIViewTestActor *)timeSelector
{
    return [self usingLabel:@"Time Selection"];
}

- (KIFUIViewTestActor * )countdownSelector
{
    return [self usingLabel:@"Countdown Selection"];
}

- (KIFUIViewTestActor *)dateCalendarSelector
{
    return [self usingLabel:@"Date Selection"];
}

- (KIFUIViewTestActor *)dateTimeCalendarSelector
{
    return [self usingLabel:@"Date Time Selection"];
}

@end


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

- (void)test_calendar_SelectingDateInPast
{
    if(@available(iOS 13.4, *)) {
        [[viewTester dateCalendarSelector] tap];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = 6;
        dateComponents.day = 17;
        dateComponents.year = 1965;
        [viewTester selectDatePickerDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
        [[[viewTester dateCalendarSelector] usingValue:@"Jun 17, 1965"] waitForView];
    }
}

- (void)test_calendar_SelectingDateInFuture
{
    if(@available(iOS 13.4, *)) {
        [[viewTester dateCalendarSelector] tap];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = 12;
        dateComponents.day = 31;
        dateComponents.year = 2030;
        [viewTester selectDatePickerDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
        [[[viewTester dateCalendarSelector] usingValue:@"Dec 31, 2030"] waitForView];
    }
}

- (void)test_calendar_SelectingDateTime
{
    if(@available(iOS 13.4, *)) {
        [[viewTester dateTimeCalendarSelector] tap];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = 6;
        dateComponents.day = 17;
        dateComponents.year = 2020;
        dateComponents.hour = 6;
        dateComponents.minute = 43;
        [viewTester selectDatePickerDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
        [[[viewTester dateTimeCalendarSelector] usingValue:@"Jun 17, 06:43 AM"] waitForView];
    }
}

#pragma mark - Wheel

- (void)test_wheels_SelectingDateInPast
{
    [[viewTester dateSelector] tap];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 6;
    dateComponents.day = 17;
    dateComponents.year = 1965;
    [viewTester selectDatePickerDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
    [[[viewTester dateSelector] usingValue:@"Jun 17, 1965"] waitForView];
}

- (void)test_wheels_SelectingDateInFuture
{
    [[viewTester dateSelector] tap];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 12;
    dateComponents.day = 31;
    dateComponents.year = 2030;
    [viewTester selectDatePickerDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
    [[[viewTester dateSelector] usingValue:@"Dec 31, 2030"] waitForView];
}

- (void)test_wheels_SelectingDateTime
{
    [[viewTester dateTimeSelector] tap];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 6;
    dateComponents.day = 17;
    dateComponents.year = 2020;
    dateComponents.hour = 6;
    dateComponents.minute = 43;
    [viewTester selectDatePickerDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
    [[[viewTester dateTimeSelector] usingValue:@"Jun 17, 06:43 AM"] waitForView];
}

- (void)test_wheels_SelectingTime
{
    [[viewTester timeSelector] tap];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = 7;
    dateComponents.minute = 44;
    [viewTester selectDatePickerDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
    [[[viewTester timeSelector] usingValue:@"7:44 AM"] waitForView];
}

#pragma mark - Countdown

- (void)testSelectingCountdown
{
    [[viewTester countdownSelector] tap];
    [viewTester selectCountdownTimerDatePickerHours:4 minutes:10];
    [[[viewTester countdownSelector] usingValue:@"15000.000000"] waitForView];
}

#pragma mark - Picker

- (void)testSelectingAPickerRow
{
    [viewTester selectPickerViewRowWithTitle:@"Echo"];

    NSOperatingSystemVersion iOS8 = {8, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"Echo"] waitForView];
    } else {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"Echo. 5 of 14"] waitForView];
    }

    [viewTester selectPickerViewRowWithTitle:@"Golf"];
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"Golf"] waitForView];
    } else {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"Golf. 7 of 14"] waitForView];
    }

    [viewTester selectPickerViewRowWithTitle:@"Alpha"];
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"Alpha"] waitForView];
    } else {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"Alpha. 1 of 14"] waitForView];
    }

    [viewTester selectPickerViewRowWithTitle:@"N8117U"];
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"N8117U"] waitForView];
    } else {
        [[[viewTester usingLabel:@"Call Sign"] usingValue:@"N8117U. 14 of 14"] waitForView];
    }
}

- (void)testSelectingRowInComponent
{
    [[viewTester dateSelector] tap];
    NSArray *date = @[ @"December", @"31", @"2030" ];
    [viewTester selectDatePickerValue:date];
    [viewTester selectDatePickerViewRowWithTitle:@"17" inComponent:1];
    [[[viewTester dateSelector] usingValue:@"Dec 17, 2030"] waitForView];
}

#pragma mark - Deprecated


- (void)test_deprecated_SelectingDateInPast
{
    [[viewTester dateSelector] tap];
    NSArray *date = @[ @"June", @"17", @"1965" ];
    // If the UIDatePicker LocaleIdentifier would be de_DE then the date to set
    // would look like this: NSArray *date = @[@"17.", @"Juni", @"1965"
    [viewTester selectDatePickerValue:date];
    [[[viewTester dateSelector] usingValue:@"Jun 17, 1965"] waitForView];
}

- (void)test_deprecated_SelectingDateInFuture
{
    [[viewTester dateSelector] tap];
    NSArray *date = @[ @"December", @"31", @"2030" ];
    [viewTester selectDatePickerValue:date];
    [[[viewTester dateSelector] usingValue:@"Dec 31, 2030"] waitForView];
}

- (void)test_deprecated_SelectingDateTime
{
    [[viewTester dateTimeSelector] tap];
    NSArray *dateTime = @[ @"Jun 17", @"6", @"43", @"AM" ];
    [viewTester selectDatePickerValue:dateTime];
    [[[viewTester dateTimeSelector] usingValue:@"Jun 17, 06:43 AM"] waitForView];
}

- (void)test_deprecated_SelectingTime
{
    [[viewTester timeSelector] tap];
    NSArray *time = @[ @"7", @"44", @"AM" ];
    [viewTester selectDatePickerValue:time];
    [[[viewTester timeSelector] usingValue:@"7:44 AM"] waitForView];
}

- (void)test_deprecated_SelectingCountdown
{
    [[viewTester countdownSelector] tap];
    NSArray *countdown = @[ @"4", @"10" ];
    [viewTester selectDatePickerValue:countdown];
    [[[viewTester countdownSelector] usingValue:@"15000.000000"] waitForView];
}

@end
