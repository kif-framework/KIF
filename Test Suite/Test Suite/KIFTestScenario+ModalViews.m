//
//  KIFTestScenario+ModalViews.m
//  Test Suite
//
//  Created by Brian K Nickel on 6/26/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "../../Classes/KIFTestScenario.h"
#import "../../Classes/KIFTestStep.h"

@interface KIFTestScenario (ModalViews)
@end

@implementation KIFTestScenario (ModalViews)

+ (instancetype)scenarioToTestAlertViews
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Alert view"];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Alert View"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Message"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Cancel"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Continue"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Continue"]];
    return scenario;
}

+ (instancetype)scenarioToTestActionSheets
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Action Sheet"];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Action Sheet"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Destroy"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"A"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"B"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Cancel"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    return scenario;
}

+ (instancetype)scenarioToTestActivityViewControllers
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Activity View Controller"];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Copy"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Mail"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Cancel"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    return scenario;
}

@end
