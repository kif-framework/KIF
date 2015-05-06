//
//  ViewWaitForTappableViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@implementation KIFUIViewTestActor (waitForTappableViewTests)

- (instancetype)bButton;
{
    return [viewTester usingAccessibilityLabel:@"B"];
}

@end

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
    [[viewTester bButton] waitToBecomeTappable];
}

- (void)testWaitingForViewWithTraits
{
    [[[viewTester bButton] usingTraits:UIAccessibilityTraitButton] waitToBecomeTappable];
}

- (void)testWaitingForViewWithValue
{
    [[[[viewTester bButton] usingValue:@"BB"] usingTraits:UIAccessibilityTraitButton] waitToBecomeTappable];
}

@end
