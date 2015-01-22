//
//  NewExistsTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@interface ExistTests_ViewTestActor : KIFTestCase
@end


@implementation ExistTests_ViewTestActor

- (void)testExistsViewWithAccessibilityLabel
{
    if ([[viewTester usingAccessibilityLabel:@"Tapping"] tryFindingTappableView] && ![[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tryFindingTappableView]) {
        [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
    } else {
        [viewTester fail];
    }

    if ([[viewTester usingAccessibilityLabel:@"Test Suite"] tryFindingTappableView] && ![[viewTester usingAccessibilityLabel:@"Tapping"] tryFindingTappableView]) {
        [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
    } else {
        [viewTester fail];
    }
}

@end
