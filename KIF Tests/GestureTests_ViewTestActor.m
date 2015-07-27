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
    [[viewTester usingLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingLabel:@"Right"] waitForView];
}

- (void)testSwipingUp
{
    [[viewTester usingLabel:@"Swipe Me"] swipeInDirection:KIFSwipeDirectionUp];
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
    [[[viewTester usingLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester usingLabel:@"Left"] waitForView];
}

- (void)testSwipingRightWithTraits
{
    [[[viewTester usingLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingLabel:@"Right"] waitForView];
}

- (void)testSwipingUpWithTraits
{
    [[[viewTester usingLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester usingLabel:@"Up"] waitForView];
}

- (void)testSwipingDownWithTraits
{
    [[[viewTester usingLabel:@"Swipe Me"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingLabel:@"Down"] waitForView];
}

- (void)testMissingSwipeableElementWithTraits
{
    KIFExpectFailure([[[[viewTester usingTimeout:0.25] usingLabel:@"Unknown"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testScrolling
{
    [[viewTester usingIdentifier:@"Scroll View"] scrollByFractionOfSizeHorizontal:-0.9 vertical:-0.9];
    [[viewTester usingLabel:@"Bottom Right"] waitToBecomeTappable];
    [[viewTester usingIdentifier:@"Scroll View"] scrollByFractionOfSizeHorizontal:0.9 vertical:0.9];
    [[viewTester usingLabel:@"Top Left"] waitToBecomeTappable];
}

- (void)testMissingScrollableElement
{
    KIFExpectFailure([[[viewTester usingTimeout:0.25] usingIdentifier:@"Unknown"] scrollByFractionOfSizeHorizontal:0.5 vertical:0.5]);
}

@end
