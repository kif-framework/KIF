//
//  AccessibilityActivateTests_ViewTestActor.m
//  KIF Tests
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <KIF/KIF.h>

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

@end
