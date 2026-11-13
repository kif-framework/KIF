//
//  SwiftUIPassThroughTests.m
//  KIF
//

@import KIF;

@interface SwiftUIPassThroughTests : KIFTestCase
@end

@implementation SwiftUIPassThroughTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"SwiftUI Pass-Through"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testTappingButtonAtEdgeOfPassThroughView
{
    [tester tapViewWithAccessibilityLabel:@"Leading button"];
    [tester waitForViewWithAccessibilityLabel:@"Tap count: 1"];
}

- (void)testTappingButtonAtEdgeOfPassThroughViewWithViewTestActor
{
    [[viewTester usingLabel:@"Leading button"] waitForTappableView];
    [[viewTester usingLabel:@"Leading button"] tap];
    [[viewTester usingLabel:@"Tap count: 1"] waitForView];
}

- (void)testTappingButtonAtCenterOfPassThroughView
{
    [tester tapViewWithAccessibilityLabel:@"Centered button"];
    [tester waitForViewWithAccessibilityLabel:@"Tap count: 1"];
}

@end
