//
//  KIFGlobals.m
//  KIF
//
//  Created by Luke Redpath on 27/07/2011
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>


@class KIFTestScenario;

typedef void (^KIFScenarioDefinitionBlock) (KIFTestScenario *);

/*!
 @abstract Defines a new scenario, passing it into block before returning it.
 @discussion This provides a slightly more concise way of defining your scenario.
 @param description A description for the scenario.
 @param block A scenario definition block, use this to add steps to your scenario.
 */
KIFTestScenario *KIFScenarioWithDescription(NSString *description, KIFScenarioDefinitionBlock block);

/*!
 @abstract Creates a new array of steps, passing it into block before returning it.
 @discussion This saves some typing of boilerplate code; just add your steps to the yielded array.
 @param block Passed in a mutable array for you to add steps to.
 */
NSArray *KIFStepCollection(void (^block)(NSMutableArray *));
