//
//  TBTestScenarios.m
//  TypistBug
//
//  Created by Pete Hodgson on 3/20/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "TBTestScenarios.h"
#import "TBTestSteps.h"

@implementation KIFTestScenario (TBTestScenarios)

+ (id)scenarioToEnterTextWithCapitalization:(BOOL)autoCapitalize;
{
    NSString *scenarioDescription = autoCapitalize ? @"Text field works WITH auto-capitalization." : @"Text field works WITHOUT auto-capitalization.";
    
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:scenarioDescription];
    [scenario addStep:[KIFTestStep stepToSetOn:autoCapitalize forSwitchWithAccessibilityLabel:@"auto-capitalize"]];
    [scenario addStep:[KIFTestStep stepToTypeIntoTheTextField:@"foo Bar baz"]];
    return scenario;
}


@end
