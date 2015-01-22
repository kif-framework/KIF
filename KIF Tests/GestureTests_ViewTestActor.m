//
//  NewGestureTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//


#import <KIF/KIF.h>
#import <KIF/KIFTestStepValidation.h>
@implementation KIFUIViewTestActor (gesturetests)

- (KIFUIViewTestActor *)swipeMe
{
    return [self usingAccessibilityLabel:@"Swipe Me"];
}
@end


@interface GestureTests_ViewTestActor : KIFTestCase
@end

@implementation GestureTests_ViewTestActor

- (void)beforeAll
{
    [[viewTester usingAccessibilityLabel:@"Gestures"] tap];
    
    // Wait for the push animation to complete before trying to interact with the view
    [viewTester waitForTimeInterval:.25];
}

- (void)afterAll
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testSwipingLeft
{
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester usingAccessibilityLabel:@"Left"] waitForView];
}

- (void)testSwipingRight
{
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingAccessibilityLabel:@"Right"] waitForView];
}

- (void)testSwipingUp
{
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester usingAccessibilityLabel:@"Up"] waitForView];
}

- (void)testSwipingDown
{
    [[viewTester swipeMe] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingAccessibilityLabel:@"Down"] waitForView];
}

- (void)testMissingSwipeableElement
{
    KIFExpectFailure([[[viewTester usingTimeout:0.25] usingAccessibilityLabel:@"Unknown"] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testSwipingLeftWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionLeft];
    [[viewTester usingAccessibilityLabel:@"Left"] waitForView];
}

- (void)testSwipingRightWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionRight];
    [[viewTester usingAccessibilityLabel:@"Right"] waitForView];
}

- (void)testSwipingUpWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionUp];
    [[viewTester usingAccessibilityLabel:@"Up"] waitForView];
}

- (void)testSwipingDownWithTraits
{
    [[[viewTester swipeMe] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown];
    [[viewTester usingAccessibilityLabel:@"Down"] waitForView];
}

- (void)testMissingSwipeableElementWithTraits
{
    KIFExpectFailure([[[[viewTester usingTimeout:0.25] usingAccessibilityLabel:@"Unknown"] usingTraits:UIAccessibilityTraitStaticText] swipeInDirection:KIFSwipeDirectionDown]);
}

- (void)testScrolling
{
    // Needs to be offset from the edge to prevent the navigation controller's interactivePopGestureRecognizer from triggering
    [[viewTester usingAccessibilityIdentifier:@"Scroll View"] scrollByFractionOfSizeHorizontal:-0.80 vertical:-0.80];
    [[viewTester usingAccessibilityLabel:@"Bottom Right"] waitToBecomeTappable];
    [[viewTester usingAccessibilityIdentifier:@"Scroll View"] scrollByFractionOfSizeHorizontal:0.80 vertical:0.80];
    [[viewTester usingAccessibilityLabel:@"Top Left"] waitToBecomeTappable];
}

- (void)testMissingScrollableElement
{
    KIFExpectFailure([[[viewTester usingTimeout:0.25] usingAccessibilityIdentifier:@"Unknown"] scrollByFractionOfSizeHorizontal:0.5 vertical:0.5]);
}

@end
