//
//  ViewTapingTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@interface ViewTappingTests : KIFTestCase
@end

@implementation ViewTappingTests

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTappingViewWithAccessibilityLabel
{
    // Since the tap has occurred in setup, we just need to wait for the result.
    [[viewTester usingAccessibilityLabel:@"TapViewController"] waitForView];
}

- (void)testTappingViewWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"X"] usingTraits:UIAccessibilityTraitButton] tap];
    [[[viewTester usingAccessibilityLabel:@"X"] usingTraits:UIAccessibilityTraitButton | UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingViewWithValue
{
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitNone] tap];
    [[viewTester usingAccessibilityLabel:@"Greeting"] waitToBecomeFirstResponder];
}

- (void)testTappingViewWithScreenAtPoint
{
    [viewTester waitForTimeInterval:0.75];
    [viewTester tapScreenAtPoint:CGPointMake(15, 200)];
    [[[viewTester usingAccessibilityLabel:@"X"] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingViewPartiallyOffscreenAndWithinScrollView
{
    [[viewTester usingAccessibilityLabel:@"Slightly Offscreen Button"] tap];
}

- (void)testTappingViewWithTapGestureRecognizer
{
    [[viewTester usingAccessibilityLabel:@"Label with Tap Gesture Recognizer"] tap];
}

- (void)testTappingLabelWithLineBreaks
{
    [[viewTester usingAccessibilityLabel:@"Label with\nLine Break\n\n"] tap];
    [[viewTester usingAccessibilityLabel:@"A\nB\nC\n\n"] tap];
}

@end
