//
//  NewGestureTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//


#import <KIF/KIF.h>
#import <KIF/KIFTestStepValidation.h>

@interface GestureTests_ViewTestActor : KIFTestCase
@end

@implementation GestureTests_ViewTestActor

- (void)beforeAll
{
    [[viewTester usingAccessibilityLabel:@"Gestures"] tap];
}

- (void)afterAll
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testSwipingLeft
{
    [[viewTester usingAccessibilityLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester usingAccessibilityLabel:@"Left"] waitForView];
}

- (void)testSwipingRight
{
    [[viewTester usingAccessibilityLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingAccessibilityLabel:@"Right"] waitForView];
}

- (void)testSwipingUp
{
    [[viewTester usingAccessibilityLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester usingAccessibilityLabel:@"Up"] waitForView];
}

- (void)testSwipingDown
{
    [[viewTester usingAccessibilityLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingAccessibilityLabel:@"Down"] waitForView];
}

- (void)testMissingSwipeableElement
{
    KIFExpectFailure([[[viewTester usingTimeout:0.25] usingAccessibilityLabel:@"Unknown"] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testSwipingLeftWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester usingAccessibilityLabel:@"Left"] waitForView];
}

- (void)testSwipingRightWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingAccessibilityLabel:@"Right"] waitForView];
}

- (void)testSwipingUpWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester usingAccessibilityLabel:@"Up"] waitForView];
}

- (void)testSwipingDownWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingAccessibilityLabel:@"Down"] waitForView];
}

- (void)testMissingSwipeableElementWithTraits
{
    KIFExpectFailure([[[[viewTester usingTimeout:0.25] usingAccessibilityLabel:@"Unknown"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testScrolling
{
    [[viewTester usingAccessibilityIdentifier:@"Scroll View"] scrollByFractionOfSizeHorizontal:-0.9 vertical:-0.9];
    [[viewTester usingAccessibilityLabel:@"Bottom Right"] waitToBecomeTappable];
    [[viewTester usingAccessibilityIdentifier:@"Scroll View"] scrollByFractionOfSizeHorizontal:0.9 vertical:0.9];
    [[viewTester usingAccessibilityLabel:@"Top Left"] waitToBecomeTappable];
}

- (void)testMissingScrollableElement
{
    KIFExpectFailure([[[viewTester usingTimeout:0.25] usingAccessibilityIdentifier:@"Unknown"] scrollByFractionOfSizeHorizontal:0.5 vertical:0.5]);
}

@end
