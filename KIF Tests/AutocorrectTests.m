//
//  AutocorrectTests.m
//  KIF Tests
//
//  Created by Harley Cooper on 2/7/18.
//

#import <KIF/KIF.h>

@interface AutocorrectTests : KIFTestCase
@end

@implementation AutocorrectTests

+ (void)setUp
{
    [KIFTestActor setEnableAutocorrect:YES];
    [KIFTestActor setEnableSmartQuotes:YES];
    [KIFTestActor setEnableSmartDashes:YES];
    [super setUp];
}

+ (void)tearDown
{
    [KIFTestActor setEnableAutocorrect:NO];
    [KIFTestActor setEnableSmartQuotes:NO];
    [KIFTestActor setEnableSmartDashes:NO];
    [super tearDown];
}

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testClearingAndEnteringTypoIntoViewWithAccessibilityLabel
{
    [[tester validateEnteredText:NO] clearTextFromAndThenEnterText:@" teh " intoViewWithAccessibilityLabel:@"Greeting"];
    [[viewTester usingValue:@" teh "] waitForAbsenceOfView];
}

- (void)testClearingAndEnteringQuotesIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"'\"'," intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"’”’,"];
}

- (void)testClearingAndEnteringDashesIntoViewWithAccessibilityLabel
{
    [tester clearTextFromAndThenEnterText:@"--a" intoViewWithAccessibilityLabel:@"Greeting" traits:UIAccessibilityTraitNone expectedResult:@"—a"];
}

@end
