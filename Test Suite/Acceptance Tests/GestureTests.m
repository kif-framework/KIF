//
//  GestureTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface GestureTests : KIFTestCase
@end

@implementation GestureTests

- (void)testSwiping
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone];
    [tester swipeViewWithAccessibilityLabel:@"Happy" inDirection:KIFSwipeDirectionLeft];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"0" traits:UIAccessibilityTraitNone];
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testScrolling
{
    [tester scrollViewWithAccessibilityLabel:@"Table View" byFractionOfSizeHorizontal:0 vertical:-0.9];
    [tester waitForViewWithAccessibilityLabel:@"Find Me"];
    [tester scrollViewWithAccessibilityLabel:@"Table View" byFractionOfSizeHorizontal:0 vertical:0.9];
    [tester waitForViewWithAccessibilityLabel:@"Tapping"];
}

@end
