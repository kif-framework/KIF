//
//  AccessibilityActivateTests_ViewTestActor.m
//  KIF Tests
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <KIF/KIF.h>
#import <UIKit/UIAccessibility.h>

@interface AccessibilityAdjustable_ViewTestActor : KIFTestCase
@end


@implementation AccessibilityAdjustable_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Accessibility"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testAccessibilityIncrement
{
    [[viewTester usingLabel:@"AccessibilityView"] performAccessibilityIncrement];
   
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
