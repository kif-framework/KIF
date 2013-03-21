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

+ (id)scenarioToEnterTextWithoutCapitalization;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Text field works without auto-capitalization."];
    [scenario addStep:[KIFTestStep stepToTypeIntoTheTextField:@"foo bar baz"]];
    return scenario;
}

@end
