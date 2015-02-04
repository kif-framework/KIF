//
//  NewScrollViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@interface ScrollViewTests_ViewTestActor : KIFTestCase
@end

@implementation ScrollViewTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"ScrollViews"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testScrollingToTapOffscreenViews
{
    [[viewTester usingAccessibilityLabel:@"Down"] tap];
    [[viewTester usingAccessibilityLabel:@"Up"] tap];
    [[viewTester usingAccessibilityLabel:@"Right"] tap];
    [[viewTester usingAccessibilityLabel:@"Left"] tap];
}

- (void)testScrollingToTapOffscreenTextView
{
    [[viewTester usingAccessibilityLabel:@"TextView"] tap];
}

@end
