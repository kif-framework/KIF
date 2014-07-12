
#import <KIF/KIF.h>

@interface FastTappingTests : KIFTestCase
@end

@implementation FastTappingTests

- (void)beforeEach
{
    [tester setAnimationSpeed:5.0]; 
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    [tester setAnimationSpeed:1.0]; // restore to default
}

- (void)testTappingViewWithAccessibilityLabel
{
    // Since the tap has occurred in setup, we just need to wait for the result.
    [tester waitForViewWithAccessibilityLabel:@"TapViewController"];
}

- (void)testTappingViewWithTraits
{
    [tester tapViewWithAccessibilityLabel:@"X" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"X" traits:UIAccessibilityTraitButton | UIAccessibilityTraitSelected];
}

- (void)testTappingViewWithValue
{
    [tester tapViewWithAccessibilityLabel:@"Greeting" value:@"Hello" traits:UIAccessibilityTraitNone];
    [tester waitForFirstResponderWithAccessibilityLabel:@"Greeting"];
}

- (void)testTappingViewWithScreenAtPoint
{
    [tester waitForTimeInterval:0.75];
    [tester tapScreenAtPoint:CGPointMake(15, 200)];
    [tester waitForViewWithAccessibilityLabel:@"X" traits:UIAccessibilityTraitSelected];
}

- (void)testTappingViewPartiallyOffscreenAndWithinScrollView
{
    [tester tapViewWithAccessibilityLabel:@"Slightly Offscreen Button"];
}

- (void)testTappingViewWithTapGestureRecognizer
{
    [tester tapViewWithAccessibilityLabel:@"Label with Tap Gesture Recognizer"];
}

- (void)testTappingLabelWithLineBreaks
{
    [tester tapViewWithAccessibilityLabel:@"Label with\nLine Break\n\n"];
    [tester tapViewWithAccessibilityLabel:@"A\nB\nC\n\n"];
}

@end
