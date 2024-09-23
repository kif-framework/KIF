//
//  LongPressTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface LongPressTests : KIFTestCase
@end

@implementation LongPressTests

- (void)beforeEach
{
    UIPasteboard.generalPasteboard.string = nil;
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}


- (void)testLongPressingViewWithAccessibilityLabel
{
    [tester tapViewWithAccessibilityLabel:@"Greeting"];
    [tester longPressViewWithAccessibilityLabel:@"Greeting" duration:2];
    [tester tapViewWithAccessibilityLabel:@"Select All"];
}

- (void)testLongPressingViewViewWithTraits
{
    [tester tapViewWithAccessibilityLabel:@"Greeting"];
    [tester longPressViewWithAccessibilityLabel:@"Greeting" value:@"Hello" duration:2];
    [tester tapViewWithAccessibilityLabel:@"Select All"];
}

- (void)testLongPressingViewViewWithValue
{
    [tester tapViewWithAccessibilityLabel:@"Greeting"];
    [tester longPressViewWithAccessibilityLabel:@"Greeting" value:@"Hello" traits:UIAccessibilityTraitUpdatesFrequently duration:2];
    [tester tapViewWithAccessibilityLabel:@"Select All"];
}

@end
