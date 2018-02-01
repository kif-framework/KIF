//
//  ViewWaitForViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>

@interface WaitForViewTests_ViewTestActor : KIFTestCase
@end


@implementation WaitForViewTests_ViewTestActor

- (void)beforeAll;
{
    [super beforeAll];

    // If a previous test was still in the process of navigating back to the main view, let that complete before starting this test
    [tester waitForAnimationsToFinish];
}

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
    [[[viewTester usingLabel:@"Switch 1"] usingValue:@"1"] waitForView];
}

@end
