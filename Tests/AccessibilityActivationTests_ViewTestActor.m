//
//  AccessibilityActivateTests_ViewTestActor.m
//  KIF Tests
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <KIF/KIF.h>
#import <UIKit/UIAccessibility.h>

@interface AccessibilityActivateTests_ViewTestActor : KIFTestCase
@end


@implementation AccessibilityActivateTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Accessibility"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testAccessibilityActivate
{
    [[viewTester usingLabel:@"AccessibilityView"] performAccessibilityActivateWithExpectedResult: YES];
    [[viewTester usingValue:@"Activated: 1"] waitForView];
    
    [[viewTester usingLabel:@"AccessibilitySwitch"] setSwitchOn:false];
    [[viewTester usingLabel:@"AccessibilityView"] performAccessibilityActivateWithExpectedResult: NO];
    [[viewTester usingValue:@"Activated: 2"] waitForView];
}

- (void)testAccessibilityActiationPoint
{
    UIView *view = [[viewTester usingValue: @"Awaiting activation or tap"] waitForView];
    [view setAccessibilityActivationPoint: [view.window convertPoint:CGPointMake(25.0, 50.0) fromView:view]];
    
    [[viewTester usingLabel: @"AccessibilityView"] tap];
    [[viewTester usingValue:@"Tapped - x:25.0000, y:50.0000"] waitForView];
    
    [view setAccessibilityActivationPoint: [view.window convertPoint:CGPointMake(50.0, 25.0) fromView:view]];
    [[viewTester usingLabel: @"AccessibilityView"] tap];
    [[viewTester usingValue:@"Tapped - x:50.0000, y:25.0000"] waitForView];
}

@end
