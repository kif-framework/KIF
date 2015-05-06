//
//  NewGestureTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//


#import <KIF/KIF.h>
#import <KIF/KIFTestStepValidation.h>
@implementation KIFUIViewTestActor (gestureTests)

- (instancetype)swipeMe
{
    return [self usingAccessibilityLabel:@"Swipe Me"];
}

- (instancetype)right;
{
    return [viewTester usingAccessibilityLabel:@"Right"];
}

- (instancetype)left;
{
    return [viewTester usingAccessibilityLabel:@"Left"];
}

- (instancetype)up;
{
    return [viewTester usingAccessibilityLabel:@"Up"];
}

- (instancetype)down;
{
    return [viewTester usingAccessibilityLabel:@"Down"];
}
@end


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
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester left] waitForView];
}

- (void)testSwipingRight
{
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester right] waitForView];
}

- (void)testSwipingUp
{
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester up] waitForView];
}

- (void)testSwipingDown
{
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester down] waitForView];
}

- (void)testMissingSwipeableElement
{
    KIFExpectFailure([[[viewTester usingTimeout:0.25] usingAccessibilityLabel:@"Unknown"] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testSwipingLeftWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester left] waitForView];
}

- (void)testSwipingRightWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester right] waitForView];
}

- (void)testSwipingUpWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester up] waitForView];
}

- (void)testSwipingDownWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester down] waitForView];
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
