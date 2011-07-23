//
//  KIFTestStep.h
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//


/*!
 @define KIFTestCondition
 @abstract Tests a condition and returns a failure result if the condition isn't true.
 @discussion This is a useful macro for quickly evaluating conditions in a test step. If the condition is false then the current test step will be aborted with a failure result.
 @param condition The condition to test.
 @param error The NSError object to put the error string into. May be nil, but should usually be the error parameter from the test step execution block.
 @param ... A string describing what the failure was that occurred. This may be a format string with additional arguments.
 */
#define KIFTestCondition(condition, error, ...) ({ \
if (!(condition)) { \
    if (error) { \
        *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:__VA_ARGS__], NSLocalizedDescriptionKey, nil]] autorelease]; \
    } \
    [KIFTestStep stepFailed]; \
    return KIFTestStepResultFailure; \
} \
})

/*!
 @define KIFTestWaitCondition
 @abstract Tests a condition and returns a wait result if the condition isn't true.
 @discussion This is a useful macro for quickly evaluating conditions in a test step. If the condition is false then the current test step will be aborted with a wait result, indicating that it should be called again in the near future.
 @param condition The condition to test.
 @param error The NSError object to put the error string into. May be nil, but should usually be the error parameter from the test step execution block.
 @param ... A string describing why the step needs to wait. This is important since this reason will be considered the cause of a timeout error if the step requires waiting for too long. This may be a format string with additional arguments.
 */
#define KIFTestWaitCondition(condition, error, ...) ({ \
if (!(condition)) { \
    if (error) { \
    *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultWait userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:__VA_ARGS__], NSLocalizedDescriptionKey, nil]] autorelease]; \
    } \
    return KIFTestStepResultWait; \
} \
})


/*!
 @enum KIFTestStepResult
 @abstract Result codes from a test step.
 @constant KIFTestStepResultFailure The step failed and the test controller should move to the next scenario.
 @constant KIFTestStepResultSuccess The step succeeded and the test controller should move to the next step in the current scenario.
 @constant KIFTestStepResultWait The test isn't ready yet and should be tried again after a short delay.
 */
enum {
    KIFTestStepResultFailure = 0,
    KIFTestStepResultSuccess,
    KIFTestStepResultWait,
};
typedef NSInteger KIFTestStepResult;


@class KIFTestStep;

/*!
 @typedef KIFTestStepExecutionBlock
 @param step The step object itself. This is passed back to the block to ensure that there is a pointer to the fully initialized step at the time of execution.
 @param error An error to fill out in the case of a failure or wait condition. Filling out this error is mandatory in these cases to ensure that testing output is useful.
 @result A test result code. Returning KIFTestStepResultWait will cause the step to be tried again on the next iteration.
 */
typedef KIFTestStepResult (^KIFTestStepExecutionBlock)(KIFTestStep *step, NSError **error);

/*!
 @class KIFTestStep
 @abstract A step in a testing sequence.
 @discussion Steps are the most basic element of a test, and are added together to create the scenarios to be tested.
 
 Steps are the building blocks of scenarios, and should be very simple. A number of useful factory steps are provided for mimicking basic user interaction. These steps leverage the built in accessibility of iOS to find and interact with views. As such, the accessibility inspector needs to be enabled under Settings in the simulator for them to work.
 */
@interface KIFTestStep : NSObject {
    KIFTestStepExecutionBlock executionBlock;
    NSString *description;
    NSTimeInterval timeout;
}

/*!
 @property timeout
 @abstract The amount of time to try the step before assuming that it failed.
 @discussion The timeout comes into play if a step returns the KIFTestStepResultWait result. If the step returns this result such that the step has been called repeatedly for a time greater than the timeout, then the step is considered to have failed. Steps are assumed to be well-behaved, and the timeout will not interrupt a step if it is running synchronously for an extended period of time.
 */
@property (nonatomic) NSTimeInterval timeout;

/*!
 @property description
 @abstract A description of what the step does.
 @discussion This is used to help describe what the test script is doing and where it may have failed.
 */
@property (nonatomic, retain) NSString *description;

/*!
 @method stepWithDescription:executionBlock:
 @abstract Convenience initializer to create a new custom step.
 @param description A description of the what the step does. Required.
 @param executionBlock A block to execute which performs the step. Required.
 */
+ (id)stepWithDescription:(NSString *)description executionBlock:(KIFTestStepExecutionBlock)executionBlock;

/*!
 @method executeAndReturnError:
 @abstract Run the execution block for the receiver.
 @discussion This method should not usually be invoked directly. The test controller will handle invoking steps as needed.
 @param error An error that can be returned if the step fails or needs to wait.
 @result The result code for the result of executing the step.
 */
- (KIFTestStepResult)executeAndReturnError:(NSError **)error;

#pragma mark Factory Steps

/*!
 @method stepThatFails
 @abstract A step that always fails.
 @discussion Mostly useful for test debugging or as a placeholder when building new tests.
 @result A configured test step.
 */
+ (id)stepThatFails;

/*!
 @method stepThatSucceeds
 @abstract A step that always succeeds.
 @discussion Mostly useful for test debugging or as a placeholder when building new tests.
 @result A configured test step.
 */
+ (id)stepThatSucceeds;

/*!
 @method stepToWaitForTimeInterval:description:
 @abstract A step that waits for a certain amount of time.
 @discussion In general when waiting for the app to get into a known state, it's better to use -stepToWaitForTappableViewWithAccessibilityLabel, however this step may be useful in some situations as well.
 @param interval The number of seconds to wait before executing the next step.
 @param description A description of why the wait is necessary. Required.
 @result A configured test step.
 */
+ (id)stepToWaitForTimeInterval:(NSTimeInterval)interval description:(NSString *)description;

+ (void)stepFailed;

@end

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#import "KIFTestStep-iOS.h"
#else
#import "KIFTestStep-Mac.h"
#endif
