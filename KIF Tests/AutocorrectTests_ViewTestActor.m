//
//  AutocorrectTests_ViewTestActor.m
//  KIF Tests
//
//  Created by Harley Cooper on 2/7/18.
//

#import <KIF/KIF.h>

@interface AutocorrectTests_ViewTestActor : KIFTestCase
@end


@implementation AutocorrectTests_ViewTestActor

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
    [[viewTester usingLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testClearingAndEnteringTypoIntoViewWithAccessibilityLabel
{
    [[[viewTester validateEnteredText:NO] usingLabel:@"Greeting"] clearAndEnterText:@" teh "];
    [[viewTester usingValue:@" teh "] waitForAbsenceOfView];
}

- (void)testClearingAndEnteringQuotesIntoViewWithAccessibilityLabel
{
    [[viewTester usingLabel:@"Greeting"] clearAndEnterText:@"'\"'," expectedResult:@"’”’,"];
}

- (void)testClearingAndEnteringDashesIntoViewWithAccessibilityLabel
{
    [[viewTester usingLabel:@"Greeting"] clearAndEnterText:@"--a" expectedResult:@"—a"];
}


@end

