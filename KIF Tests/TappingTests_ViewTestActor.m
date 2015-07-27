//
//  ViewTappingTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@interface TappingTests_ViewTestActor : KIFTestCase
@end


@implementation TappingTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTappingViewWithAccessibilityLabel
{
    // Since the tap has occurred in setup, we just need to wait for the result.
    [[viewTester usingLabel:@"TapViewController"] waitForView];
}

- (void)testTappingViewWithTraits
{
    [[[viewTester usingLabel:@"X"] usingTraits:UIAccessibilityTraitButton] tap];
    [[[viewTester usingLabel:@"X"] usingTraits:UIAccessibilityTraitButton | UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingViewWithValue
{
    [[[[viewTester usingLabel:@"Greeting"] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitNone] tap];
    [[viewTester usingLabel:@"Greeting"] waitToBecomeFirstResponder];
}

- (void)testTappingViewWithScreenAtPoint
{
    [viewTester waitForTimeInterval:0.75];
    [viewTester tapScreenAtPoint:CGPointMake(15, 200)];
    [[[viewTester usingLabel:@"X"] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingViewPartiallyOffscreenAndWithinScrollView
{
    [[viewTester usingLabel:@"Slightly Offscreen Button"] tap];
}

- (void)testTappingViewWithTapGestureRecognizer
{
    [[viewTester usingLabel:@"Label with Tap Gesture Recognizer"] tap];
}

- (void)testTappingLabelWithLineBreaks
{
    [[viewTester usingLabel:@"Label with\nLine Break\n\n"] tap];
    [[viewTester usingLabel:@"A\nB\nC\n\n"] tap];
}

@end
