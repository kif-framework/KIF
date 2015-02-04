//
//  ViewWaitForTappableViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@interface WaitForTappableViewTests_ViewTestActor : KIFTestCase
@end


@implementation WaitForTappableViewTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"Show/Hide"] tap];
    [[viewTester usingAccessibilityLabel:@"Cover/Uncover"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testWaitingForTappableViewWithAccessibilityLabel
{
    [[viewTester usingAccessibilityLabel:@"B"] waitToBecomeTappable];
}

- (void)testWaitingForViewWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"B"] usingTraits:UIAccessibilityTraitButton] waitToBecomeTappable];
}

- (void)testWaitingForViewWithValue
{
    [[[[viewTester usingAccessibilityLabel:@"B"] usingValue:@"BB"] usingTraits:UIAccessibilityTraitButton] waitToBecomeTappable];
}

@end
