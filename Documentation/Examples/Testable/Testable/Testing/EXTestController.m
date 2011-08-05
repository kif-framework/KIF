//
//  EXTestController.m
//  Testable
//
//  Created by Eric Firestone on 6/3/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "EXTestController.h"
#import "KIFTestScenario+EXAdditions.h"

@implementation EXTestController

- (void)initializeScenarios;
{
//    [self addScenario:[KIFTestScenario scenarioToLogin]];
    [self addScenario:[KIFTestScenario scenarioToSelectDifferentColors]];
}

@end
