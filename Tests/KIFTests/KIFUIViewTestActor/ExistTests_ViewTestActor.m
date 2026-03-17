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
    // If a previous test was still in the process of navigating back to the main view, let that complete before starting this test.
    [[[viewTester usingAnimationWaitingTimeout:5.0] usingAnimationStabilizationTimeout:0.0] waitForAnimationsToFinish];

    if ([[viewTester usingLabel:@"Tapping"] tryFindingTappableView] && ![[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tryFindingTappableView]) {
        // This test will fail if the view controller hasn't fully finished animating in, so give it a lot of time to complete the animation.
        [[[viewTester usingLabel:@"Tapping"] usingAnimationWaitingTimeout:5.0] tap];
    } else {
        [viewTester fail];
    }

    if ([[viewTester usingLabel:@"Test Suite"] tryFindingTappableView] && ![[viewTester usingLabel:@"Tapping"] tryFindingTappableView]) {
        [[[[viewTester usingLabel:@"Test Suite"] usingAnimationWaitingTimeout:5.0] usingTraits:UIAccessibilityTraitButton] tap];
    } else {
        [viewTester fail];
    }
}

@end
