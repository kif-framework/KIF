//
//  NewExistsTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@interface NewExistTests : KIFTestCase
@end


@implementation NewExistTests

- (void)testExistsViewWithAccessibilityLabel
{
    if ([[viewTester usingLabel:@"Tapping"] tryFindingTappableView] && ![[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tryFindingTappableView]) {
        [[viewTester usingLabel:@"Tapping"] tap];
    } else {
        [viewTester fail];
    }

    if ([[viewTester usingLabel:@"Test Suite"] tryFindingTappableView] && ![[viewTester usingLabel:@"Tapping"] tryFindingTappableView]) {
        [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
    } else {
        [tester fail];
    }
}

@end
