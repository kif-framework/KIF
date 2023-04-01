//
//  OffscreenTests.m
//  KIF Tests
//
//  Created by Steve Sun on 2023-03-28.
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@interface OffscreenTests : KIFTestCase
@end

@implementation OffscreenTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Offscreen Views"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testViewOffscreen
{
    [tester tapViewWithAccessibilityLabel:@"Scroll moving view"];
    [tester tapViewWithAccessibilityLabel:@"Move and hide views"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Out of screen view"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Alpha view"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Hidden view"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Scroll moving view"];
}

@end
