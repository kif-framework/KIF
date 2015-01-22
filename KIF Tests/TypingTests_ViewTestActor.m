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

- (instancetype)greeting;
{
    return [viewTester usingAccessibilityLabel:@"Greeting"];
}

- (instancetype)selectAll;
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
    [[[[viewTester greeting] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitNone] tap];
    [[viewTester greeting] waitToBecomeFirstResponder];
}

- (void)testMissingFirstResponder
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityLabel:@"Greeting"] waitToBecomeFirstResponder]);
}

- (void)testEnteringTextIntoFirstResponder
{
    [[[viewTester greeting] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester selectAll] tap];
    [viewTester enterTextIntoCurrentFirstResponder:@"Yo"];
    [[[[viewTester greeting] usingValue:@"Yo"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testFailingToEnterTextIntoFirstResponder
{
    KIFExpectFailure([[viewTester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"Yo"]);
}

- (void)testEnteringTextIntoViewWithAccessibilityLabel
{
    [[[viewTester greeting] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester selectAll] tap];
    [[viewTester usingAccessibilityLabel:@"Cut"] tap];
    [[viewTester greeting] enterText:@"Yo"];
    [[[[viewTester greeting] usingValue:@"Yo"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testEnteringTextIntoViewWithAccessibilityLabelExpectingResults
{
    [[[viewTester greeting] usingTraits:UIAccessibilityTraitNone] enterText:@", world" expectedResult:@"Hello, world"];
    [[[[viewTester greeting] usingValue:@"Hello, world"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testClearingAndEnteringTextIntoViewWithAccessibilityLabel
{
    [[viewTester greeting] clearAndEnterText:@"Yo"];
}

- (void)testEnteringReturnCharacterIntoViewWithAccessibilityLabel
{
    [[viewTester otherText] enterText:@"Hello\n"];
    [[viewTester greeting] waitToBecomeFirstResponder];
    [[viewTester greeting] waitForView];
    [[[viewTester greeting] usingTraits:UIAccessibilityTraitNone] enterText:@", world\n" expectedResult:@"Hello, world"];
}

- (void)testClearingALongTextField
{
    [[viewTester greeting] clearAndEnterText:@"A man, a plan, a canal, Panama.  Able was I, ere I saw Elba."];
    [[viewTester greeting] clearText];
}

- (void)testThatClearingTextHitsTheDelegate
{
    [[viewTester otherText] enterText:@"hello"];
    [[viewTester otherText] clearText];
    [[[[viewTester greeting] usingValue:@"Deleted something."] usingTraits:UIAccessibilityTraitNone] waitForView];
}

- (void)testThatBackspaceDeletesOneCharacter
{
    [[[viewTester otherText] usingTraits:UIAccessibilityTraitNone] enterText:@"hi\bello" expectedResult:@"hello"];
    [[[[viewTester greeting] usingValue:@"Deleted something."] usingTraits:UIAccessibilityTraitNone] waitForView];
}

@end
