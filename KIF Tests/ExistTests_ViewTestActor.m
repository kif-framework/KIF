//
//  NewExistsTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>
@implementation KIFUIViewTestActor (absenceTests)

- (instancetype)absenceTestsTapping;
{
    return [viewTester usingAccessibilityLabel:@"Tapping"];
}

- (instancetype)absenceTestsTestSuite;
{
    return [viewTester usingAccessibilityLabel:@"Test Suite"];
}

@end


@interface ExistTests_ViewTestActor : KIFTestCase
@end


@implementation ExistTests_ViewTestActor

- (void)testExistsViewWithAccessibilityLabel
{
    if ([[viewTester absenceTestsTapping] tryFindingTappableView] && ![[[viewTester absenceTestsTestSuite] usingTraits:UIAccessibilityTraitButton] tryFindingTappableView]) {
        [[viewTester absenceTestsTapping] tap];
    } else {
        [viewTester fail];
    }

    if ([[viewTester absenceTestsTestSuite] tryFindingTappableView] && ![[viewTester absenceTestsTapping] tryFindingTappableView]) {
        [[[viewTester absenceTestsTestSuite] usingTraits:UIAccessibilityTraitButton] tap];
    } else {
        [viewTester fail];
    }
}

@end
