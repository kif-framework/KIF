//
//  ViewWaitForViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@interface NewWaitForViewTests : KIFTestCase
@end

@implementation NewWaitForViewTests

- (void)testWaitingForViewWithAccessibilityLabel
{
    [[viewTester usingLabel:@"Test Suite"] waitForView];
}

- (void)testWaitingForViewWithTraits
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitStaticText] waitForView];
}

- (void)testWaitingForViewWithValue
{
    [[[[viewTester usingLabel:@"Switch 1"] usingValue:@"1"] usingTraits:UIAccessibilityTraitNone] waitForView];
}

@end
