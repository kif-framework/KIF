//
//  ViewTypingTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@interface TypingTests_ViewTestActor : KIFTestCase
@end


@implementation TypingTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testWaitingForFirstResponder
{
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitNone] tap];
    [[viewTester usingAccessibilityLabel:@"Greeting"] waitToBecomeFirstResponder];
}

- (void)testMissingFirstResponder
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityLabel:@"Greeting"] waitToBecomeFirstResponder]);
}

- (void)testEnteringTextIntoFirstResponder
{
    [[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
    [viewTester enterTextIntoCurrentFirstResponder:@"Yo"];
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Yo"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testFailingToEnterTextIntoFirstResponder
{
    KIFExpectFailure([[viewTester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"Yo"]);
}

- (void)testEnteringTextIntoViewWithAccessibilityLabel
{
    [[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
    [[viewTester usingAccessibilityLabel:@"Cut"] tap];
    [[viewTester usingAccessibilityLabel:@"Greeting"] enterText:@"Yo"];
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Yo"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testEnteringTextIntoViewWithAccessibilityLabelExpectingResults
{
    [[[viewTester usingAccessibilityLabel:@"Greeting"] usingTraits:UIAccessibilityTraitNone] enterText:@", world" expectedResult:@"Hello, world"];
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello, world"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testClearingAndEnteringTextIntoViewWithAccessibilityLabel
{
    [[viewTester usingAccessibilityLabel:@"Greeting"] clearAndEnterText:@"Yo"];
}

- (void)testEnteringReturnCharacterIntoViewWithAccessibilityLabel
{
    [[viewTester usingAccessibilityLabel:@"Other Text"] enterText:@"Hello\n"];
    [[viewTester usingAccessibilityLabel:@"Greeting"] waitToBecomeFirstResponder];
    [[viewTester usingAccessibilityLabel:@"Greeting"] waitForView];
    [[[viewTester usingAccessibilityLabel:@"Greeting"] usingTraits:UIAccessibilityTraitNone] enterText:@", world\n" expectedResult:@"Hello, world"];
}

- (void)testClearingALongTextField
{
    [[viewTester usingAccessibilityLabel:@"Greeting"] clearAndEnterText:@"A man, a plan, a canal, Panama.  Able was I, ere I saw Elba."];
    [[viewTester usingAccessibilityLabel:@"Greeting"] clearText];
}

- (void)testThatClearingTextHitsTheDelegate
{
    [[viewTester usingAccessibilityLabel:@"Other Text"] enterText:@"hello"];
    [[viewTester usingAccessibilityLabel:@"Other Text"] clearText];
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Deleted something."] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testThatBackspaceDeletesOneCharacter
{
    [[[viewTester usingAccessibilityLabel:@"Other Text"] usingTraits:UIAccessibilityTraitNone] enterText:@"hi\bello" expectedResult:@"hello"];
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Deleted something."] usingTraits:UIAccessibilityTraitNone] waitForView];
}

@end
