//
//  NewGestureTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//


#import <KIF/KIF.h>
#import <KIF/KIFTestStepValidation.h>

@interface GestureTests : KIFTestCase
@end

@implementation GestureTests

- (void)beforeAll
{
    [[viewTester usingLabel:@"Gestures"] tap];
}

- (void)afterAll
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testSwipingLeft
{
    [[viewTester usingLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester usingLabel:@"Left"] waitForView];
}

- (void)testSwipingRight
{
    [[viewTester usingLabel:@"Swiper Me"] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingLabel:@"Right"] waitForView];
}

- (void)testSwipingUp
{
    [[viewTester usingLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingLabel:@"Up"] waitForView];
}

- (void)testSwipingDown
{
    [[viewTester usingLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingLabel:@"Down"] waitForView];
}

- (void)testMissingSwipeableElement
{
    KIFExpectFailure([[[viewTester usingTimeout:0.25] usingLabel:@"Unknown"] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testSwipingLeftWithTraits
{
    [[[[viewTester usingLabel:@"Swipe Me"] usingValue:nil] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester usingLabel:@"Left"] waitForView];
}

- (void)testSwipingRightWithTraits
{
    [[[[viewTester usingLabel:@"Swipe Me"] usingValue:nil] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingLabel:@"Right"] waitForView];
}

- (void)testSwipingUpWithTraits
{
    [[[[viewTester usingLabel:@"Swipe Me"] usingValue:nil] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester usingLabel:@"Up"] waitForView];
}

- (void)testSwipingDownWithTraits
{
    [[[[viewTester usingLabel:@"Swipe Me"] usingValue:nil] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingLabel:@"Down"] waitForView];
}

- (void)testMissingSwipeableElementWithTraits
{
    KIFExpectFailure([[[[viewTester usingTimeout:0.25] usingLabel:@"Unknown"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testScrolling
{
    [tester scrollViewWithAccessibilityIdentifier:@"Scroll View" byFractionOfSizeHorizontal:-0.9 vertical:-0.9];
    [tester waitForTappableViewWithAccessibilityLabel:@"Bottom Right"];
    [tester scrollViewWithAccessibilityIdentifier:@"Scroll View" byFractionOfSizeHorizontal:0.9 vertical:0.9];
    [tester waitForTappableViewWithAccessibilityLabel:@"Top Left"];
}

- (void)testMissingScrollableElement
{
    KIFExpectFailure([[tester usingTimeout:0.25] scrollViewWithAccessibilityIdentifier:@"Unknown" byFractionOfSizeHorizontal:0.5 vertical:0.5]);
}

@end
