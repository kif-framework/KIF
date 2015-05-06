//
//  ViewTappingTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@implementation KIFUIViewTestActor (tappingtests)

- (KIFUIViewTestActor *)tappingTestsXButton;
{
    return [[self usingAccessibilityLabel:@"X"] usingTraits:UIAccessibilityTraitButton];
}

- (KIFUIViewTestActor *)tappingTestsGreeting;
{
    return [self usingAccessibilityLabel:@"Greeting"];
}

@end

@interface TappingTests_ViewTestActor : KIFTestCase
@end


@implementation TappingTests_ViewTestActor

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
    [[viewTester tappingTestsXButton] tap];
    [[[viewTester tappingTestsXButton] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingViewWithValue
{
    [[[[viewTester tappingTestsGreeting] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitNone] tap];
    [[viewTester tappingTestsGreeting] waitToBecomeFirstResponder];
}

- (void)testTappingViewWithScreenAtPoint
{
    [viewTester waitForTimeInterval:0.75];
    [viewTester tapScreenAtPoint:CGPointMake(15, 200)];
    [[[viewTester tappingTestsXButton] usingTraits:UIAccessibilityTraitSelected] waitForView];
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
