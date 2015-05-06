//
//  ViewTypingTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@implementation KIFUIViewTestActor (typingTests)

- (instancetype)typingTestsGreeting;
{
    return [viewTester usingAccessibilityLabel:@"Greeting"];
}

- (instancetype)typingTestsSelectAll;
{
    return [viewTester usingAccessibilityLabel:@"Select All"];
}

- (instancetype)otherText;
{
    return [viewTester usingAccessibilityLabel:@"Other Text"];
}

@end


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
    [[[[viewTester typingTestsGreeting] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitNone] tap];
    [[viewTester typingTestsGreeting] waitToBecomeFirstResponder];
}

- (void)testMissingFirstResponder
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityLabel:@"Greeting"] waitToBecomeFirstResponder]);
}

- (void)testEnteringTextIntoFirstResponder
{
    [[[viewTester typingTestsGreeting] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester typingTestsSelectAll] tap];
    [viewTester enterTextIntoCurrentFirstResponder:@"Yo"];
    [[[[viewTester typingTestsGreeting] usingValue:@"Yo"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testFailingToEnterTextIntoFirstResponder
{
    KIFExpectFailure([[viewTester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"Yo"]);
}

- (void)testEnteringTextIntoViewWithAccessibilityLabel
{
    [[[viewTester typingTestsGreeting] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester typingTestsSelectAll] tap];
    [[viewTester usingAccessibilityLabel:@"Cut"] tap];
    [[viewTester typingTestsGreeting] enterText:@"Yo"];
    [[[[viewTester typingTestsGreeting] usingValue:@"Yo"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testEnteringTextIntoViewWithAccessibilityLabelExpectingResults
{
    [[[viewTester typingTestsGreeting] usingTraits:UIAccessibilityTraitNone] enterText:@", world" expectedResult:@"Hello, world"];
    [[[[viewTester typingTestsGreeting] usingValue:@"Hello, world"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testClearingAndEnteringTextIntoViewWithAccessibilityLabel
{
    [[viewTester typingTestsGreeting] clearAndEnterText:@"Yo"];
}

- (void)testEnteringReturnCharacterIntoViewWithAccessibilityLabel
{
    [[viewTester otherText] enterText:@"Hello\n"];
    [[viewTester typingTestsGreeting] waitToBecomeFirstResponder];
    [[viewTester typingTestsGreeting] waitForView];
    [[[viewTester typingTestsGreeting] usingTraits:UIAccessibilityTraitNone] enterText:@", world\n" expectedResult:@"Hello, world"];
}

- (void)testClearingALongTextField
{
    [[viewTester typingTestsGreeting] clearAndEnterText:@"A man, a plan, a canal, Panama.  Able was I, ere I saw Elba."];
    [[viewTester typingTestsGreeting] clearText];
}

- (void)testThatClearingTextHitsTheDelegate
{
    [[viewTester otherText] enterText:@"hello"];
    [[viewTester otherText] clearText];
    [[[[viewTester typingTestsGreeting] usingValue:@"Deleted something."] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testThatBackspaceDeletesOneCharacter
{
    [[[viewTester otherText] usingTraits:UIAccessibilityTraitNone] enterText:@"hi\bello" expectedResult:@"hello"];
    [[[[viewTester typingTestsGreeting] usingValue:@"Deleted something."] usingTraits:UIAccessibilityTraitNone] waitForView];
}

@end
