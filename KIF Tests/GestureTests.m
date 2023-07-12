//
//  GestureTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>
#import <KIF/KIFTestStepValidation.h>
#import <KIF/KIFUITestActor-IdentifierTests.h>
#import <KIF/UIView-KIFAdditions.h>

#define kPanMeAccessibilityString               @"Pan Me"
#define kVelocityValueLabelAccessibilityString  @"velocityValueLabel"

#define kPanLeftRegex                           @"^X:-[0-9\\.]+ Y:0.00$"
#define kPanUpRegex                             @"^X:0.00 Y:-[0-9\\.]+$"
#define kPanRightRegex                          @"^X:[0-9\\.]+ Y:0.00$"
#define kPanDownRegex                           @"^X:0.00 Y:[0-9\\.]+$"
#define KPanNoVelocityValue                     @"^X:0.00 Y:0.00$"

@interface GestureTests : KIFTestCase
@end

@implementation GestureTests

- (void)beforeAll
{
    [tester tapViewWithAccessibilityLabel:@"Gestures"];

    // Wait for the push animation to complete before trying to interact with the view
    [tester waitForTimeInterval:.25];
}

- (void)afterAll
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
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

- (void)testPanningLeft
{
    NSString* regexPattern = kPanLeftRegex;
    NSPredicate *resultTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPattern];
    NSPredicate *noVelocityPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", KPanNoVelocityValue];
    
    UIView* velocityResultView = [tester waitForViewWithAccessibilityLabel:kVelocityValueLabelAccessibilityString];
    XCTAssertTrue([velocityResultView isKindOfClass:[UILabel class]], @"Found view is not a UILabel instance!");
    UILabel* velocityLabel = (UILabel*)velocityResultView;
    
    UIView* panLabel = [tester waitForTappableViewWithAccessibilityLabel:kPanMeAccessibilityString];
    CGPoint centerInView = CGPointMake(panLabel.frame.size.width / 2.0, panLabel.frame.size.height / 2.0);
    
    [panLabel dragFromPoint:centerInView toPoint:CGPointMake(centerInView.x - 30, centerInView.y)];
    XCTAssertFalse([noVelocityPredicate evaluateWithObject:velocityLabel.text], @"No valocity value found!");
    XCTAssertTrue([resultTestPredicate evaluateWithObject:velocityLabel.text], @"The result doesn`t match the %@ regex pattern", regexPattern);
}

- (void)testPanningRight
{
    NSString* regexPattern = kPanRightRegex;
    NSPredicate *resultTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPattern];
    NSPredicate *noVelocityPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", KPanNoVelocityValue];
    
    UIView* velocityResultView = [tester waitForViewWithAccessibilityLabel:kVelocityValueLabelAccessibilityString];
    XCTAssertTrue([velocityResultView isKindOfClass:[UILabel class]], @"Found view is not a UILabel instance!");
    UILabel* velocityLabel = (UILabel*)velocityResultView;
    
    UIView* panLabel = [tester waitForTappableViewWithAccessibilityLabel:kPanMeAccessibilityString];
    CGPoint offCenterInView = CGPointMake((panLabel.frame.size.width * 0.6), panLabel.frame.size.height / 2.0);
    
    [panLabel dragFromPoint:offCenterInView toPoint:CGPointMake(offCenterInView.x + 30, offCenterInView.y)];
    XCTAssertFalse([noVelocityPredicate evaluateWithObject:velocityLabel.text], @"No valocity value found!");
    XCTAssertTrue([resultTestPredicate evaluateWithObject:velocityLabel.text], @"The result doesn`t match the %@ regex pattern", regexPattern);
}

- (void)testPanningUp
{
    NSString* regexPattern = kPanUpRegex;
    NSPredicate *resultTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPattern];
    NSPredicate *noVelocityPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", KPanNoVelocityValue];
    
    UIView* velocityResultView = [tester waitForViewWithAccessibilityLabel:kVelocityValueLabelAccessibilityString];
    XCTAssertTrue([velocityResultView isKindOfClass:[UILabel class]], @"Found view is not a UILabel instance!");
    UILabel* velocityLabel = (UILabel*)velocityResultView;
    
    UIView* panLabel = [tester waitForTappableViewWithAccessibilityLabel:kPanMeAccessibilityString];
    CGPoint centerInView = CGPointMake(panLabel.frame.size.width / 2.0, panLabel.frame.size.height / 2.0);
    
    [panLabel dragFromPoint:centerInView toPoint:CGPointMake(centerInView.x, centerInView.y - 30)];
    XCTAssertFalse([noVelocityPredicate evaluateWithObject:velocityLabel.text], @"No valocity value found!");
    XCTAssertTrue([resultTestPredicate evaluateWithObject:velocityLabel.text], @"The result doesn`t match the %@ regex pattern", regexPattern);
}


- (void)testPanningDown
{
    NSString* regexPattern = kPanDownRegex;
    NSPredicate *resultTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPattern];
    NSPredicate *noVelocityPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", KPanNoVelocityValue];
    
    UIView* velocityResultView = [tester waitForViewWithAccessibilityLabel:kVelocityValueLabelAccessibilityString];
    XCTAssertTrue([velocityResultView isKindOfClass:[UILabel class]], @"Found view is not a UILabel instance!");
    UILabel* velocityLabel = (UILabel*)velocityResultView;
    
    UIView* panLabel = [tester waitForTappableViewWithAccessibilityLabel:kPanMeAccessibilityString];
    CGPoint centerInView = CGPointMake(panLabel.frame.size.width / 2.0, panLabel.frame.size.height / 2.0);
    
    [panLabel dragFromPoint:centerInView toPoint:CGPointMake(centerInView.x, centerInView.y + 30)];
    XCTAssertFalse([noVelocityPredicate evaluateWithObject:velocityLabel.text], @"No valocity value found!");
    XCTAssertTrue([resultTestPredicate evaluateWithObject:velocityLabel.text], @"The result doesn`t match the %@ regex pattern", regexPattern);
}

- (void)testMissingSwipeableElement
{
    KIFExpectFailure([[tester usingTimeout:0.25] swipeViewWithAccessibilityLabel:@"Unknown" inDirection:KIFSwipeDirectionDown]);
}

- (void)testSwipingLeftWithTraits
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" value:nil traits:UIAccessibilityTraitStaticText inDirection:KIFSwipeDirectionLeft];
    [tester waitForViewWithAccessibilityLabel:@"Left"];
}

- (void)testSwipingRightWithTraits
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" value:nil traits:UIAccessibilityTraitStaticText inDirection:KIFSwipeDirectionRight];
    [tester waitForViewWithAccessibilityLabel:@"Right"];
}

- (void)testSwipingUpWithTraits
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" value:nil traits:UIAccessibilityTraitStaticText inDirection:KIFSwipeDirectionUp];
    [tester waitForViewWithAccessibilityLabel:@"Up"];
}

- (void)testSwipingDownWithTraits
{
    [tester swipeViewWithAccessibilityLabel:@"Swipe Me" value:nil traits:UIAccessibilityTraitStaticText inDirection:KIFSwipeDirectionDown];
    [tester waitForViewWithAccessibilityLabel:@"Down"];
}

- (void)testMissingSwipeableElementWithTraits
{
    KIFExpectFailure([[tester usingTimeout:0.25] swipeViewWithAccessibilityLabel:@"Unknown" value:nil traits:UIAccessibilityTraitStaticText inDirection:KIFSwipeDirectionDown]);
}

- (void)testSwipingLeftWithIdentifier
{
    [tester swipeViewWithAccessibilityIdentifier:@"gestures.swipeMe" inDirection:KIFSwipeDirectionLeft];
    [tester waitForViewWithAccessibilityLabel:@"Left"];
}

- (void)testSwipingRightWithIdentifier
{
    [tester swipeViewWithAccessibilityIdentifier:@"gestures.swipeMe" inDirection:KIFSwipeDirectionRight];
    [tester waitForViewWithAccessibilityLabel:@"Right"];
}

- (void)testSwipingUpWithIdentifier
{
    [tester swipeViewWithAccessibilityIdentifier:@"gestures.swipeMe" inDirection:KIFSwipeDirectionUp];
    [tester waitForViewWithAccessibilityLabel:@"Up"];
}

- (void)testSwipingDownWithIdentifier
{
    [tester swipeViewWithAccessibilityIdentifier:@"gestures.swipeMe" inDirection:KIFSwipeDirectionDown];
    [tester waitForViewWithAccessibilityLabel:@"Down"];
}

- (void)testSwipingFromScreenEdgeLeft
{
    UIView *view = [tester waitForViewWithAccessibilityIdentifier:@"gestures.swipeMe"];
    CGSize windowSize = view.window.bounds.size;
    CGPoint point = CGPointMake(0.5, 200);
    point = [view convertPoint:point fromView:view.window];
    KIFDisplacement displacement = CGPointMake(windowSize.width * 0.5, 5);
    [view dragFromPoint:point displacement:displacement steps:20];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"LeftEdge"];
    
    [tester swipeFromEdge:UIRectEdgeLeft];
    [tester waitForViewWithAccessibilityLabel:@"LeftEdge"];
}

- (void)testSwipingFromScreenEdgeRight
{
    UIView *view = [tester waitForViewWithAccessibilityIdentifier:@"gestures.swipeMe"];
    CGSize windowSize = view.window.bounds.size;
    CGPoint point = CGPointMake(windowSize.width - 0.5, 200);
    point = [view convertPoint:point fromView:view.window];
    KIFDisplacement displacement = CGPointMake(-windowSize.width * 0.5, 5);
    [view dragFromPoint:point displacement:displacement steps:20];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"RightEdge"];
    
    [tester swipeFromEdge:UIRectEdgeRight];
    [tester waitForViewWithAccessibilityLabel:@"RightEdge"];
}

- (void)testScrolling
{
    // Needs to be offset from the edge to prevent the navigation controller's interactivePopGestureRecognizer from triggering
    [tester scrollViewWithAccessibilityIdentifier:@"Scroll View" byFractionOfSizeHorizontal:-0.30 vertical:-0.30];
    [tester waitForTappableViewWithAccessibilityLabel:@"Bottom Right"];
    [tester scrollViewWithAccessibilityIdentifier:@"Scroll View" byFractionOfSizeHorizontal:0.30 vertical:0.30];
    [tester waitForTappableViewWithAccessibilityLabel:@"Top Left"];
}

- (void)testMissingScrollableElement
{
    KIFExpectFailure([[tester usingTimeout:0.25] scrollViewWithAccessibilityIdentifier:@"Unknown" byFractionOfSizeHorizontal:0.5 vertical:0.5]);
}

@end
