//
//  KIFTestScenario+EXAdditions.m
//  Testable
//
//  Created by Eric Firestone on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KIFTestScenario+EXAdditions.h"
#import <KIF/KIFTestStep.h>
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

+ (id)scenarioToSelectColor:(NSString *)colorName;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:[NSString stringWithFormat:@"Select the color %@", colorName]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Red"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Selected: Red"]];
    
    return scenario;
}

@end
