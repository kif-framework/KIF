//
//  AutocorrectTests_ViewTestActor.m
//  KIF Tests
//
//  Created by Harley Cooper on 2/7/18.
//

#import <KIF/KIF.h>

#import "KIFTextInputTraitsOverrides.h"

@interface AutocorrectTests_ViewTestActor : KIFTestCase
@end


@implementation AutocorrectTests_ViewTestActor

+ (void)setUp
{
    [super setUp];

    KIFTextInputTraitsOverrides.allowDefaultAutocorrectBehavior = YES;
    KIFTextInputTraitsOverrides.allowDefaultSmartDashesBehavior = YES;
    KIFTextInputTraitsOverrides.allowDefaultSmartQuotesBehavior = YES;
}

+ (void)tearDown
{
    [super tearDown];

    KIFTextInputTraitsOverrides.allowDefaultAutocorrectBehavior = NO;
    KIFTextInputTraitsOverrides.allowDefaultSmartDashesBehavior = NO;
    KIFTextInputTraitsOverrides.allowDefaultSmartQuotesBehavior = NO;
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
    [[[viewTester validateEnteredText:NO] usingLabel:@"Greeting"] clearAndEnterText:@" jkasd "];
    [[viewTester usingValue:@" jkasd "] waitForAbsenceOfView];
}

// These tests won't work on any version of iOS before iOS 11.
#ifdef __IPHONE_11_0
- (void)testClearingAndEnteringQuotesIntoViewWithAccessibilityLabel
{
    [[viewTester usingLabel:@"Greeting"] clearAndEnterText:@"'\"'," expectedResult:@"’”’,"];
}

- (void)testClearingAndEnteringDashesIntoViewWithAccessibilityLabel
{
    [[viewTester usingLabel:@"Greeting"] clearAndEnterText:@"--a" expectedResult:@"—a"];
}
#endif

@end

