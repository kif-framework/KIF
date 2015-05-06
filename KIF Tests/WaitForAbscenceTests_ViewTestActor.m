//
//  NewWaitForAbsenceTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@implementation KIFUIViewTestActor (absenceTests)

- (instancetype)tapping;
{
    return [viewTester usingAccessibilityLabel:@"Tapping"];
}

@end

@interface WaitForAbscenceTests_ViewTestActor : KIFTestCase
@end


@implementation WaitForAbscenceTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester tapping] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testWaitingForAbsenceOfViewWithAccessibilityLabel
{
    [[viewTester tapping] waitForAbsenceOfView];
}

- (void)testWaitingForAbsenceOfViewWithTraits
{
    [[[viewTester tapping] usingTraits:UIAccessibilityTraitStaticText] waitForAbsenceOfView];
}

- (void)testWaitingForAbsenceOfViewWithValue
{
    [[[[viewTester usingAccessibilityLabel:@"Switch 1"] usingValue:@"1"] usingTraits:UIAccessibilityTraitNone] waitForAbsenceOfView];
}

@end
