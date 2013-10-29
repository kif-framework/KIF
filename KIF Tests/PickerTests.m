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


- (void)testSelectingAPickerRow
{
    [tester tapViewWithAccessibilityLabel:@"Date Selection"];
    [tester stepToEnterDate:@"June" day:@"17" year:@"1965"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Jun 17, 1965"];
}

@end
