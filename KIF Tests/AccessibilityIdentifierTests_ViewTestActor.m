//
//  NewAccessibilityIdentifierTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>
#import <KIF/KIFTestStepValidation.h>

@implementation KIFUIViewTestActor (accessibilityIdentifierTests)

- (instancetype)xButton;
{
    return [viewTester usingAccessibilityIdentifier:@"X_BUTTON"];
}

- (instancetype)notXButton;
{
    return [viewTester usingAccessibilityIdentifier:@"NOT_X_BUTTON"];
}

- (instancetype)idGreeting;
{
return [viewTester usingAccessibilityIdentifier:@"idGreeting"];
}

@end

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
    [[viewTester xButton] waitForView];
    KIFExpectFailure([[[viewTester notXButton] usingTimeout:0.5] waitForView]);
}

- (void)testTappingViewWithAccessibilityIdentifier
{
    [[viewTester xButton] tap];
    [[[viewTester usingAccessibilityLabel:@"X"] usingTraits:UIAccessibilityTraitButton | UIAccessibilityTraitSelected] waitForView];
    KIFExpectFailure([[[viewTester notXButton] usingTimeout:0.5] tap]);
}

- (void)testWaitingForAbscenceOfViewWithAccessibilityIdentifier
{
    // Since the tap has occurred in setup, we just need to wait for the result.
    [[viewTester xButton] waitForView];
    [[viewTester notXButton] waitForAbsenceOfView];
    KIFExpectFailure([[[viewTester notXButton] usingTimeout:0.5] waitForView]);
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
    [[viewTester xButton] waitForAbsenceOfView];
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)testLongPressingViewWithAccessibilityIdentifier
{
    [[viewTester idGreeting] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
}

- (void)testEnteringTextIntoViewWithAccessibilityIdentifier
{
    [[viewTester idGreeting] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
    [[viewTester usingAccessibilityLabel:@"Cut"] tap];
    [[viewTester idGreeting] enterText:@"Yo"];
}

- (void)testEnteringTextIntoViewWithAccessibilityIdentifierExpectingResults
{
    [[viewTester idGreeting] enterText:@", world" expectedResult:@"Hello, world"];
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello, world"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testClearingAndEnteringTextIntoViewWithAccessibilityLabel
{
    [[viewTester idGreeting] clearAndEnterText:@"Yo"];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

@end
