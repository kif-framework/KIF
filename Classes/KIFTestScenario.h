//
//  KIFTestScenario.h
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>


@class KIFTestStep;

/*!
 @class KIFTestScenario
 @abstract A single scenario to be tested.
 @discussion A scenario represents a small, but cohesive unit of testing that usually maps to an available user action, such as logging in, or sending a message. Scenarios are comprised of smaller steps (represented by KIFTestSteps) for discrete interactions, such as tapping a button.
 
   A convenient practice is to add a category on KIFTestScenario which includes factory methods to create the scenarios you want to test. This provides a useful identifier for each scenario via the method name (something like +scenarioToLogInSuccessfully), and also provides an organized place for your application-specific scenarios.
 */
@interface KIFTestScenario : NSObject {
    NSMutableArray *steps;
    NSString *description;
    BOOL skippedByFilter;
}

/*!
 @property description
 @abstract A description of what the scenario tests.
 @discussion This should be a thorough description of what the scenario is testing so that if the test fails, it is clear which test it was.
 */
@property (nonatomic, retain) NSString *description;

/*!
 @property steps
 @abstract The steps that comprise the scenario.
 @discussion The steps are instances of KIFTestStep (or a subclass).
 */
@property (nonatomic, readonly, retain) NSArray *steps;

/*!
 @property skippedByFilter
 @abstract Whether this scenario is being skipped
 @discussion Set the KIF_SCENARIO_FILTER environment variable to skip all scenarios not matching the variable's value
 */
@property (nonatomic, readonly) BOOL skippedByFilter;

/*!
 @method scenarioWithDescription
 @abstract Create a new scenario.
 @param description A description of what the scenario is testing.
 @result An initialized scenario.
 @discussion Creates a new instance of the scenario with a given description. As part of creating the instance, @link initializeSteps initializeSteps @/link will be called, so calling this method on a subclass of KIFTestScenario will return a fully initialized scenario.
 */
+ (id)scenarioWithDescription:(NSString *)description;

/*!
 @method initializeSteps;
 @abstract A place for subclasses to add steps.
 @discussion This is lazily called the first time the steps property is accessed. Subclasses can use model information to customize the set of steps that are returned.
 */
- (void)initializeSteps;

/*!
 @method addStep:
 @abstract Add a step to the scenario.
 */
- (void)addStep:(KIFTestStep *)step;

/*!
 @method addStepsFromArray:
 @abstract Add multiple steps to the scenario from an array.
 */
- (void)addStepsFromArray:(NSArray *)steps;

@end
