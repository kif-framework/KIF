#import <KIF/KIF.h>

@interface PickerTests : KIFTestCase
@end

@implementation PickerTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Pickers"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testSelectingDateInPast
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    NSArray *date = @[@"June", @"17", @"1965"];
    // If the UIDatePicker LocaleIdentifier would be de_DE then the date to set
    // would look like this: NSArray *date = @[@"17.", @"Juni", @"1965"
    [tester selectDateFromPicker:date];
    [tester waitForTappableViewWithAccessibilityLabel:@"Jun 17, 1965"];
}

- (void)testSelectingDateInFuture
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    NSArray *date = @[@"December", @"31", @"2030"];
    [tester selectDateFromPicker:date];
    [tester waitForTappableViewWithAccessibilityLabel:@"Dec 31, 2030"];
}

- (void)testSelectingDateTime
{
    [tester tapViewWithAccessibilityLabel:@"Date Time Selection"];
    NSArray *dateTime = @[@"Jun 17", @"6", @"43", @"AM"];
    [tester selectDateFromPicker:dateTime];
    [tester waitForTappableViewWithAccessibilityLabel:@"Sunday, Jun 17, 06:43 AM"];
}

- (void)testSelectingAPickerRow
{
    [tester selectPickerViewRowWithTitle:@"Charlie"];
    [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Charlie. 3 of 3" traits:UIAccessibilityTraitNone];
}

@end
