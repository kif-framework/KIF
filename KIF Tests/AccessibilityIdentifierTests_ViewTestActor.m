//
//  NewAccessibilityIdentifierTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>
#import <KIF/KIFTestStepValidation.h>

@interface AccessibilityIdentifierTests_ViewTestActor : KIFTestCase
@end


@implementation AccessibilityIdentifierTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)testWaitingForViewWithAccessibilityIdentifier
{
    // Since the tap has occurred in setup, we just need to wait for the result.
    [[viewTester usingAccessibilityIdentifier:@"X_BUTTON"] waitForView];
    KIFExpectFailure([[[viewTester usingTimeout:0.5] usingAccessibilityIdentifier:@"NOT_X_BUTTON"] waitForView]);
}

- (void)testTappingViewWithAccessibilityIdentifier
{
    [[viewTester usingAccessibilityIdentifier:@"X_BUTTON"] tap];
    [[[viewTester usingAccessibilityLabel:@"X"] usingTraits:UIAccessibilityTraitButton | UIAccessibilityTraitSelected] waitForView];
    KIFExpectFailure([[[viewTester usingTimeout:0.5] usingAccessibilityIdentifier:@"NOT_X_BUTTON"] tap]);
}

- (void)testWaitingForAbscenceOfViewWithAccessibilityIdentifier
{
    // Since the tap has occurred in setup, we just need to wait for the result.
    [[viewTester usingAccessibilityIdentifier:@"X_BUTTON"] waitForView];
    [[viewTester usingAccessibilityIdentifier:@"NOT_X_BUTTON"] waitForAbsenceOfView];
    KIFExpectFailure([[[viewTester usingTimeout:0.5] usingAccessibilityIdentifier:@"X_BUTTON"] waitForAbsenceOfView]);
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
    [[viewTester usingAccessibilityIdentifier:@"X_BUTTON"] waitForAbsenceOfView];
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)testLongPressingViewWithAccessibilityIdentifier
{
    [[viewTester usingAccessibilityIdentifier:@"idGreeting"] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
}

- (void)testEnteringTextIntoViewWithAccessibilityIdentifier
{
    [[viewTester usingAccessibilityIdentifier:@"idGreeting"] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
    [[viewTester usingAccessibilityLabel:@"Cut"] tap];
    [[viewTester usingAccessibilityIdentifier:@"idGreeting"] enterText:@"Yo"];
}

- (void)testEnteringTextIntoViewWithAccessibilityIdentifierExpectingResults
{
    [[viewTester usingAccessibilityIdentifier:@"idGreeting"] enterText:@", world" expectedResult:@"Hello, world"];
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello, world"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testClearingAndEnteringTextIntoViewWithAccessibilityLabel
{
    [[viewTester usingAccessibilityIdentifier:@"idGreeting"] clearAndEnterText:@"Yo"];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

@end
