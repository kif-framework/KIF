
#import <KIF/KIF.h>

@interface FastLandscapeTests : KIFTestCase
@end

@implementation FastLandscapeTests

- (void)beforeAll
{
    [tester setAnimationSpeed:5.0];
    [system simulateDeviceRotationToOrientation:UIDeviceOrientationLandscapeLeft];
    [tester scrollViewWithAccessibilityIdentifier:@"Test Suite TableView" byFractionOfSizeHorizontal:0 vertical:-0.2];
}

- (void)afterAll
{
    [system simulateDeviceRotationToOrientation:UIDeviceOrientationPortrait];
    [tester waitForTimeInterval:0.25];
    [tester setAnimationSpeed:1.0]; // restore to default
}

- (void)beforeEach
{
    [tester waitForTimeInterval:0.25];
}

- (void)testThatAlertViewsCanBeTappedInLandscape
{
    [tester tapViewWithAccessibilityLabel:@"UIAlertView"];
    [tester tapViewWithAccessibilityLabel:@"Continue"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Message"];
}

@end
