//
//  KIFTestHelperMethods.m
//  KIF
//
//  Created by Luke Redpath on 25/07/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KIFTestHelperMethods.h"
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
