
#import <KIF/KIF.h>

@interface FastPickerTests : KIFTestCase
@end

@implementation FastPickerTests

- (void)beforeEach
{
    [tester setAnimationSpeed:5.0];
    [tester tapViewWithAccessibilityLabel:@"Pickers"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    [tester setAnimationSpeed:1.0]; // restore to default
}

- (void)testSelectingDateInPast
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    NSArray *date = @[@"June", @"17", @"1965"];
    // If the UIDatePicker LocaleIdentifier would be de_DE then the date to set
    // would look like this: NSArray *date = @[@"17.", @"Juni", @"1965"
    [tester selectDatePickerValue:date];
    [tester waitForViewWithAccessibilityLabel:@"Date Selection" value:@"Jun 17, 1965" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingDateInFuture
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    NSArray *date = @[@"December", @"31", @"2030"];
    [tester selectDatePickerValue:date];
    [tester waitForViewWithAccessibilityLabel:@"Date Selection" value:@"Dec 31, 2030" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingDateTime
{
    [tester tapViewWithAccessibilityLabel:@"Date Time Selection"];
    NSArray *dateTime = @[@"Jun 17", @"6", @"43", @"AM"];
    [tester selectDatePickerValue:dateTime];
    [tester waitForViewWithAccessibilityLabel:@"Date Time Selection" value:@"Sunday, Jun 17, 06:43 AM" traits:UIAccessibilityTraitNone];
    ;
}

- (void)testSelectingTime
{
    [tester tapViewWithAccessibilityLabel:@"Time Selection"];
    NSArray *time = @[@"7", @"44", @"AM"];
    [tester selectDatePickerValue:time];
    [tester waitForViewWithAccessibilityLabel:@"Time Selection" value:@"7:44 AM" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingCountdown
{
    [tester tapViewWithAccessibilityLabel:@"Countdown Selection"];
    NSArray *countdown = @[@"4", @"10"];
    [tester selectDatePickerValue:countdown];
    [tester waitForViewWithAccessibilityLabel:@"Countdown Selection" value:@"15000.000000" traits:UIAccessibilityTraitNone];
}

- (void)testSelectingAPickerRow
{
    [tester selectPickerViewRowWithTitle:@"Charlie"];
    [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Charlie. 3 of 3" traits:UIAccessibilityTraitNone];
}

@end
