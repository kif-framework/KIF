//
//  KIFTestHelperMethods.h
//  KIF
//
//  Created by Luke Redpath on 25/07/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

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
