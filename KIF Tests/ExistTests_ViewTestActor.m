//
//  NewExistsTests.m
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

- (instancetype)testSuite;
{
    return [viewTester usingAccessibilityLabel:@"Test Suite"];
}

@end


@interface ExistTests_ViewTestActor : KIFTestCase
@end


@implementation ExistTests_ViewTestActor

- (void)testExistsViewWithAccessibilityLabel
{
    if ([[viewTester tapping] tryFindingTappableView] && ![[[viewTester testSuite] usingTraits:UIAccessibilityTraitButton] tryFindingTappableView]) {
        [[viewTester tapping] tap];
    } else {
        [viewTester fail];
    }

    if ([[viewTester testSuite] tryFindingTappableView] && ![[viewTester tapping] tryFindingTappableView]) {
        [[[viewTester testSuite] usingTraits:UIAccessibilityTraitButton] tap];
    } else {
        [viewTester fail];
    }
}

@end
