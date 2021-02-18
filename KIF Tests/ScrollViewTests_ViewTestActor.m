//
//  NewScrollViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIView-KIFAdditions.h"

@interface ScrollViewTests_ViewTestActor : KIFTestCase
@end

@implementation ScrollViewTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"ScrollViews"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testScrollingToTapOffscreenViews
{
    [[viewTester usingLabel:@"Down"] tap];
    [[viewTester usingLabel:@"Up"] tap];
    [[viewTester usingLabel:@"Right"] tap];
    [[viewTester usingLabel:@"Left"] tap];
}

- (void)testScrollingToTapOffscreenTextView
{
    [[viewTester usingLabel:@"TextView"] tap];
}

- (void)testScrollingDownAndUp
{
    [[viewTester usingLabel:@"Long Scroll View"] scrollByFractionOfSizeHorizontal:0 vertical:-1];
    [[viewTester usingLabel:@"Bottom Label"] waitForView];

    [[viewTester usingLabel:@"Long Scroll View"] scrollByFractionOfSizeHorizontal:0 vertical:1];
    [[viewTester usingLabel:@"Top Label"] waitForView];
}

@end
