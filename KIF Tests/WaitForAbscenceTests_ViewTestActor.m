//
//  NewWaitForAbsenceTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@interface WaitForAbscenceTests_ViewTestActor : KIFTestCase
@end


@implementation WaitForAbscenceTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testWaitingForAbsenceOfViewWithAccessibilityLabel
{
    [[viewTester usingAccessibilityLabel:@"Tapping"] waitForAbsenceOfView];
}

- (void)testWaitingForAbsenceOfViewWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"Tapping"] usingTraits:UIAccessibilityTraitStaticText] waitForAbsenceOfView];
}

- (void)testWaitingForAbsenceOfViewWithValue
{
    [[[[viewTester usingAccessibilityLabel:@"Switch 1"] usingValue:@"1"] usingTraits:UIAccessibilityTraitNone] waitForAbsenceOfView];
}

@end
