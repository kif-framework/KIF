//
//  KIFGlobals.m
//  KIF
//
//  Created by Luke Redpath on 27/07/2011
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFGlobals.h"
#import "KIFTestScenario.h"


KIFTestScenario *KIFScenarioWithDescription(NSString *description, KIFScenarioDefinitionBlock block)
{
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:description];
  block(scenario);
  return scenario;
}

NSArray *KIFStepCollection(void (^block)(NSMutableArray *))
{
  NSMutableArray *steps = [NSMutableArray array];
  block(steps);
  return [[steps copy] autorelease];
}
