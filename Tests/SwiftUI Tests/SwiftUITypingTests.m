//
//  SwiftUITypingTests.m
//  KIF
//
//  Created by Bartłomiej Włodarczak on 10/02/2025.
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@interface SwiftUITypingTests : KIFTestCase
@end

@implementation SwiftUITypingTests

- (void)beforeEach
{
    UIPasteboard.generalPasteboard.string = nil;
    [tester tapViewWithAccessibilityLabel:@"SwiftUI Typing"];
}

- (void)afterEach
{
    UIPasteboard.generalPasteboard.string = nil;
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testWaitingForFirstResponder
{
    [tester tapViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"This is SwiftUI TextField" traits:UIAccessibilityTraitNone];
    [tester waitForFirstResponderWithAccessibilityLabel:@"SwiftUI TextField"];
}

- (void)testMissingFirstResponder
{
    KIFExpectFailure([[tester usingTimeout:1] waitForFirstResponderWithAccessibilityLabel:@"SwiftUI TextField"]);
}

- (void)testEnteringTextIntoFirstResponder
{
    [tester tapViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester enterTextIntoCurrentFirstResponder:@"Hello from SwiftUI TextField"];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"Hello from SwiftUI TextField" traits:UIAccessibilityTraitNone];
    [tester clearTextFromViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Hello from SwiftUI TextField"];
}

- (void)testFailingToEnterTextIntoFirstResponder
{
    KIFExpectFailure([[tester usingTimeout:1] enterTextIntoCurrentFirstResponder:@"Sup"]);
}

- (void)testFillingAndClearingTextField
{
    [tester tapViewWithAccessibilityLabel:@"Fill text field"];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"This is some inserted text" traits: UIAccessibilityTraitNone];
    [tester tapViewWithAccessibilityLabel:@"Clear text field"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"This is some inserted text" traits:UIAccessibilityTraitNone];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"This is SwiftUI TextField" traits:UIAccessibilityTraitNone];
}

- (void)testClearingTextFromFirstResponder
{
    [tester tapViewWithAccessibilityLabel:@"Fill text field"];
    [tester clearTextFromAndThenEnterText:@"A man, a plan, a canal, Panama.  Able was I, ere I saw Elba." intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester clearTextFromFirstResponder];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"A man, a plan, a canal, Panama.  Able was I, ere I saw Elba." traits:UIAccessibilityTraitNone];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"This is SwiftUI TextField" traits:UIAccessibilityTraitNone];
}

- (void)testClearingTextFromViewWithAccessibilityLabel
{
    [tester tapViewWithAccessibilityLabel:@"Fill text field"];
    [tester clearTextFromAndThenEnterText:@"A man, a plan, a canal, Panama.  Able was I, ere I saw Elba." intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester clearTextFromViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"A man, a plan, a canal, Panama.  Able was I, ere I saw Elba." traits:UIAccessibilityTraitNone];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"This is SwiftUI TextField" traits:UIAccessibilityTraitNone];
}

- (void)testEnteringReturnCharacterIntoViewWithAccessibilityLabel
{
    [tester enterText:@"Hello\n" intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester waitForViewWithAccessibilityLabel:@"Hello"];
    KIFExpectFailure([[tester usingTimeout:1] waitForFirstResponderWithAccessibilityLabel:@"SwiftUI TextField"]);
}

- (void)testEnteringEmojiCharactersIntoViewWithAccessibilityLabel
{
    NSString *text = @" 😓He😤ll👿o";
    [tester enterText:text intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:text traits:UIAccessibilityTraitNone];
    [tester waitForViewWithAccessibilityLabel:text];
}

- (void)testSelectingAllAndTypingAgain
{
    [tester tapViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester enterTextIntoCurrentFirstResponder:@"Thi"];
    [tester longPressViewWithAccessibilityLabel:@"SwiftUI TextField" duration:1];
    [tester tapViewWithAccessibilityLabel:@"Select All"];
    [tester enterTextIntoCurrentFirstResponder:@"This should overwrite current text"];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"This should overwrite current text" traits:UIAccessibilityTraitNone];
    [tester waitForViewWithAccessibilityLabel:@"This should overwrite current text"];
}

- (void)testThatBackspaceDeletesOneCharacter
{
    [tester enterText:@"hi\bello" intoViewWithAccessibilityLabel:@"SwiftUI TextField" traits:UIAccessibilityTraitNone expectedResult:@"Hello"];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:@"Hello" traits:UIAccessibilityTraitNone];
    [tester waitForViewWithAccessibilityLabel:@"Hello"];
}

- (void)testClearingAndEnteringTextIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"Yo" intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
}

- (void)testClearingAndEnteringQuotesIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"'\"'," intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
}

- (void)testClearingAndEnteringDashesIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"--a" intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
}

- (void)testClearingAndEnteringTypoIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@" Jkasd " intoViewWithAccessibilityLabel:@"SwiftUI TextField"];
}

- (void)testPastingTextIntoTextField
{
    NSString *text = @"This is a text from pasteboard";
    UIPasteboard.generalPasteboard.string = text;
    [tester longPressViewWithAccessibilityLabel:@"SwiftUI TextField" duration:1];
    [tester tapViewWithAccessibilityLabel:@"Paste"];
    [tester waitForViewWithAccessibilityLabel:@"SwiftUI TextField" value:text traits:UIAccessibilityTraitNone];
    [tester waitForViewWithAccessibilityLabel:text];
}

- (void)testCopyingTextIntoPasteboard
{
    NSString *text = @"Text";
    [tester tapViewWithAccessibilityLabel:@"SwiftUI TextField"];
    [tester enterTextIntoCurrentFirstResponder:text];
    [tester longPressViewWithAccessibilityLabel:@"SwiftUI TextField" duration:1];
    [tester tapViewWithAccessibilityLabel:@"Select"];
    [tester tapViewWithAccessibilityLabel:@"Copy"];
    XCTAssertEqualObjects(UIPasteboard.generalPasteboard.string, text);
}

@end
