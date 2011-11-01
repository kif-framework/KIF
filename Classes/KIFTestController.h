//
//  KIFTestController.h
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>
#import "KIFTestScenario.h"
#import "KIFTestStep.h"


typedef void (^KIFTestControllerCompletionBlock)();

/*!
 @class KIFTestController
 @abstract The singleton controller in charge of running the integration tests.
 @discussion The KIFTestController class is the test runner for KIF integration tests. It should be configured with a list of KIFTestScenarios to run. It will run the scenarios sequentially, aborting any given scenario and moving on to the next if a step in the scenario fails.
 
  The controller can be set up in one of two primary ways:
 
  Subclassing (Preferred)
  Create a subclass of KIFTestController for your application. This class will encapsulate the logic of which scenarios to run, and helps minimize the amount of testing code within your core application. Your subclass should override the -initializeScenarios method, and in that method the scenarios to run should be created and added to the controller using -addScenario:. The -initializeScenarios method will be called automatically as part of starting the testing. To start running the tests, your application code then just needs to call the code below.
   <pre>
    [[YOURTestController sharedInstance] startTestingWithCompletionBlock:nil];
   </pre>
 
   Construction
   You can initialize the test controller without subclassing by iteratively creating and adding scenarios (using -addScenario:) somewhere in your application code. You can then start testing by calling the code below.
   <pre>
    [[KIFTestController sharedInstance] startTestingWithCompletionBlock:nil];
   </pre>
 */
@interface KIFTestController : NSObject {
    NSMutableArray *scenarios;
    BOOL testing;
    KIFTestControllerCompletionBlock completionBlock;
    
    KIFTestScenario *currentScenario;
    KIFTestStep *currentStep;
    
    NSDate *testSuiteStartDate;
    NSDate *currentStepStartDate;
    NSDate *currentScenarioStartDate;
    
    NSInteger failureCount;
    NSInteger completeScenarioCount;
    NSMutableIndexSet *failedScenarioIndexes;
    NSURL *failedScenarioFile;
}

/*!
 @property scenarios
 @abstract The scenarios that comprise the testing suite.
 @discussion You can add scenarios to the testing suite using -addScenario:
 */
@property (nonatomic, readonly, retain) NSArray *scenarios;

/*!
 @property testing
 @abstract Whether or not the test suite is currently running.
 */
@property (nonatomic, readonly, getter=isTesting) BOOL testing;

/*!
 @property currentScenario
 @abstract The scenario that is currently being run.
 */
@property (nonatomic, readonly, retain) KIFTestScenario *currentScenario;

/*!
 @property currentStep
 @abstract The step in the current scenario that is currently being run.
 */
@property (nonatomic, readonly, retain) KIFTestStep *currentStep;

/*!
 @property failureCount
 @abstract The number of failed scenarios so far.
 */
@property (nonatomic, readonly) NSInteger failureCount;

/*!
 @method sharedInstance
 @abstract Retrieves the singleton instance of the test controller.
 @discussion The test controller class should never be allocated manually. You should always use the singleton retrieved using this method.
  If you subclass KIFTestController, then you should invoke your subclass's version of this class method to insure that the singleton is of the correct class type.
 @result The singleton instance of the test controller.
 */
+ (id)sharedInstance;

/*!
 @method initializeScenarios
 @abstract Configures the scenarios to run for the test suite.
 @discussion The default implementation of this method does nothing. Subclasses should override it so that it configures the scenarios for the test controller to run. This method is invoked automatically and should never need to be invoked manually.
 */
- (void)initializeScenarios;

/*!
 @method addAllScenarios
 @abstract Add all scenarios to the test suite.
 @discussion This enumerates the list of class methods on KIFTestScenario and adds those starting with "scenario" alphabetically.
 */
- (void)addAllScenarios;

/*!
 @method addScenariosWithSelectorPrefix:fromClass:
 @abstract Add all scenarios to the test suite with a selector prefix.
 @discussion This enumerates the list of class methods on the given class and adds those starting with the given prefix alphabetically.
 @param selectorPrefix Added selectors must have this prefix.
 @param klass The class to search for scenarios.
 */
- (void)addAllScenariosWithSelectorPrefix:(NSString *)selectorPrefix fromClass:(Class)klass;

/*!
 @method addScenario:
 @abstract Add a scenario to the test suite.
 @discussion Scenarios will be run in the order that they're added.
 @param scenario The scenario to add to the test suite.
 */
- (void)addScenario:(KIFTestScenario *)scenario;

/*!
 @method startTestingWithCompletionBlock:
 @abstract Start the test suite.
 @discussion Testing is done asynchronously by inserting itself into the run loop at appropriate times. As such, this method will not block. To be notified when testing is complete, implement the completionBlock.
 @param completionBlock An optional execution block that will be invoked when testing is complete.
 */
- (void)startTestingWithCompletionBlock:(KIFTestControllerCompletionBlock)completionBlock;

@end
