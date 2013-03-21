//
//  TBTestController.m
//  TypistBug
//
//  Created by Pete Hodgson on 3/20/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "TBTestController.h"
#import "TBTestScenarios.h"

@implementation TBTestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToEnterTextWithoutCapitalization]];
    // Add additional scenarios you want to test here
}

@end