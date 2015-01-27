//
//  ViewWaitForAnimationTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@interface ViewWaitForAnimationTests : KIFTestCase

@end

@implementation ViewWaitForAnimationTests

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
    [[viewTester usingAccessibilityLabel:@"Animations"] tap];
}

- (void)afterEach
{
    [[viewTester usingAccessibilityLabel:@"Back"] tap];
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testWaitForFinishingAnimation
{
    [viewTester tapScreenAtPoint:CGPointMake(100, 100)];
    [[viewTester usingAccessibilityLabel:@"Label"] waitForView];
}

@end
