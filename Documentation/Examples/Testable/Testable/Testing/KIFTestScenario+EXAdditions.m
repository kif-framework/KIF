//
//  KIFTestScenario+EXAdditions.m
//  Testable
//
//  Created by Eric Firestone on 6/12/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestScenario+EXAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+EXAdditions.h"

@implementation KIFTestScenario (EXAdditions)

+ (id)scenarioToLogin;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStepsFromArray:[KIFTestStep stepsToGoToLoginPage]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"user@example.com" intoViewWithAccessibilityLabel:@"Login User Name"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"thisismypassword" intoViewWithAccessibilityLabel:@"Login Password"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log In"]];
    
    // Verify that the login succeeded
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Welcome"]];
    
    return scenario;
}

+ (id)scenarioToSelectDifferentColors;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:[NSString stringWithFormat:@"Select the a few different colors."]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Purple"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Blue"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Red"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:5.0 description:@"An arbitrary wait just to demonstrate adding an additional step"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Selected: Red"]];
    
    return scenario;
}

@end
