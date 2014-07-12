//
//  FastAnimationTests.m
//  KIF
//
//  Created by David Rönnqvist on 12/07/14.
//
//

#import <KIF/KIF.h>
#import <KIF/UIApplication-KIFAdditions.h>

#import <KIF/KIFTestStepValidation.h> // for gesture tests

/*!
 Runs a mixture of table view tests at 5x animation speed
 */

@interface FastTableViewTests : KIFTestCase
@end

@implementation FastTableViewTests

- (void)beforeEach
{
    [tester setAnimationSpeed:5.0]; // 5x the animation speed
    [tester tapViewWithAccessibilityLabel:@"TableViews"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    [tester setAnimationSpeed:1.0]; // restore to default
}

- (void)testSpeedUpSearchField
{
    [tester tapViewWithAccessibilityLabel:nil traits:UIAccessibilityTraitSearchField];
    [tester waitForFirstResponderWithAccessibilityLabel:nil traits:UIAccessibilityTraitSearchField];
    [tester enterTextIntoCurrentFirstResponder:@"text"];
    [tester waitForViewWithAccessibilityLabel:nil value:@"text" traits:UIAccessibilityTraitSearchField];
}


- (void)testSpeedUpScrollingToTop
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] inTableViewWithAccessibilityIdentifier:@"TableView Tests Table"];
    [tester tapStatusBar];
    
    UITableView *tableView;
    [tester waitForAccessibilityElement:NULL view:&tableView withIdentifier:@"TableView Tests Table" tappable:NO];
    [tester runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(tableView.contentOffset.y == - tableView.contentInset.top, error, @"Waited for scroll view to scroll to top, but it ended at %@", NSStringFromCGPoint(tableView.contentOffset));
        return KIFTestStepResultSuccess;
    }];
}

@end



/*!
 Runs the typing tests at 2x the animation speed
 */

@interface FastTypingTests : KIFTestCase
@end

@implementation FastTypingTests

- (void)beforeEach
{
    [tester setAnimationSpeed:2.0]; // 2x the animation speed
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    [tester setAnimationSpeed:1.0]; // restore to default
}


- (void)testWaitingForFirstResponder
{
    [tester tapViewWithAccessibilityLabel:@"Greeting" value:@"Hello" traits:UIAccessibilityTraitNone];
    [tester waitForFirstResponderWithAccessibilityLabel:@"Greeting"];
}

- (void)testEnteringTextIntoFirstResponder
{
    [tester longPressViewWithAccessibilityLabel:@"Greeting" value:@"Hello" duration:2];
    [tester tapViewWithAccessibilityLabel:@"Select All"];
    [tester enterTextIntoCurrentFirstResponder:@"Yo"];
    [tester waitForViewWithAccessibilityLabel:@"Greeting" value:@"Yo" traits:UIAccessibilityTraitNone];
}

- (void)testEnteringTextIntoViewWithAccessibilityLabel
{
    [tester longPressViewWithAccessibilityLabel:@"Greeting" value:@"Hello" duration:2];
    [tester tapViewWithAccessibilityLabel:@"Select All"];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    [tester enterText:@"Yo" intoViewWithAccessibilityLabel:@"Greeting"];
    [tester waitForViewWithAccessibilityLabel:@"Greeting" value:@"Yo" traits:UIAccessibilityTraitNone];
}

- (void)testEnteringTextIntoViewWithAccessibilityLabelExpectingResults
{
    [tester enterText:@", world" intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"Hello, world"];
    [tester waitForViewWithAccessibilityLabel:@"Greeting" value:@"Hello, world" traits:UIAccessibilityTraitNone];
}

- (void)testClearingAndEnteringTextIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"Yo" intoViewWithAccessibilityLabel:@"Greeting"];
}

- (void)testEnteringReturnCharacterIntoViewWithAccessibilityLabel
{
    [tester enterText:@"Hello\n" intoViewWithAccessibilityLabel:@"Other Text"];
    [tester waitForFirstResponderWithAccessibilityLabel:@"Greeting"];
    [tester enterText:@", world\n" intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"Hello, world"];
}

@end



/*!
 Runs the Tapping tests at 10x the animation speed
 */

@interface FastTappingTests : KIFTestCase
@end

@implementation FastTappingTests

- (void)beforeEach
{
    [tester setAnimationSpeed:10.0]; // 10x the animation speed
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    [tester setAnimationSpeed:1.0]; // restore do default
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

@end



/*!
 Runs the gesture tests at 3.5x the animation speed
 */

@interface FastGestureTests : KIFTestCase
@end

@implementation FastGestureTests

- (void)beforeAll
{
    [tester setAnimationSpeed:3.5]; // 3.5x the animation speed
    [tester tapViewWithAccessibilityLabel:@"Gestures"];
}

- (void)afterAll
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    [tester setAnimationSpeed:1.0]; // restore do default
}

- (void)testSwipingLeft
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" inDirection:KIFSwipeDirectionLeft];
    [tester waitForViewWithAccessibilityLabel:@"Left"];
}

- (void)testSwipingRight
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" inDirection:KIFSwipeDirectionRight];
    [tester waitForViewWithAccessibilityLabel:@"Right"];
}

- (void)testSwipingUp
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" inDirection:KIFSwipeDirectionUp];
    [tester waitForViewWithAccessibilityLabel:@"Up"];
}

- (void)testSwipingDown
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" inDirection:KIFSwipeDirectionDown];
    [tester waitForViewWithAccessibilityLabel:@"Down"];
}

- (void)testMissingSwipeableElement
{
    KIFExpectFailure([[tester usingTimeout:0.25] swipeViewWithAccessibilityLabel:@"Unknown" inDirection:KIFSwipeDirectionDown]);
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
