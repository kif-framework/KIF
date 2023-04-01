//
//  OffscreenTests_ViewTestActor.m
//  KIF Tests
//
//  Created by Steve Sun on 2023-03-31.
//

#import <KIF/KIF.h>
#import "KIFUITestActor.h"

@interface OffscreenTests_ViewTestActor : KIFTestCase
@end


@implementation OffscreenTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Offscreen Views"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testViewOffscreen
{
    [[viewTester usingLabel:@"Scroll moving view"] tap];
    [[viewTester usingLabel:@"Move and hide views"] tap];
    [[viewTester usingLabel:@"Out of screen view"] waitForAbsenceOfView];
    [[viewTester usingLabel:@"Alpha view"] waitForAbsenceOfView];
    [[viewTester usingLabel:@"Hidden view"] waitForAbsenceOfView];
    [[viewTester usingLabel:@"Scroll moving view"] waitForAbsenceOfView];
}

@end
