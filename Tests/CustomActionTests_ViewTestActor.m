//
//  CustomActionTests_ViewTestActor.m
//  KIF Tests
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <KIF/KIF.h>

@interface CustomActionTests_ViewTestActor : KIFTestCase
@end


@implementation CustomActionTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Accessibility"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testCustomActions
{
    if (@available(iOS 13.0, *)) {
        [[viewTester usingLabel:@"AccessibilityView"] activateCustomActionWithName:@"Action With block handler"];
    }
    
    for (NSString *name in @[@"Action without argument", @"Action with argument"]) {
        [[viewTester usingLabel:@"AccessibilityView"] activateCustomActionWithName:name];
    }
    
    [[viewTester usingLabel:@"AccessibilityView"] activateCustomActionWithName:@"Action that fails" expectedResult:NO];
}

@end
