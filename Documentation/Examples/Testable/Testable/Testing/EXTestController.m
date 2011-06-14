//
//  EXTestController.m
//  Testable
//
//  Created by Eric Firestone on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EXTestController.h"
#import "KIFTestScenario+EXAdditions.h"

@implementation EXTestController

- (void)initializeScenarios;
{
//    [self addScenario:[KIFTestScenario scenarioToLogin]];
    [self addScenario:[KIFTestScenario scenarioToSelectColor:@"Red"]];
}

@end
