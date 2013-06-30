//
//  KIFTester.h
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>

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
*error = [NSError errorWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:__VA_ARGS__], NSLocalizedDescriptionKey, nil]]; \
} \
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
*error = [NSError errorWithDomain:@"KIFTest" code:KIFTestStepResultWait userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:__VA_ARGS__], NSLocalizedDescriptionKey, nil]]; \
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

/*!
 @typedef KIFTestExecutionBlock
 @param error An error to fill out in the case of a failure or wait condition. Filling out this error is mandatory in these cases to ensure that testing output is useful.
 @result A test result code. Returning KIFTestStepResultWait will cause the block to be tried again on the next iteration.
 */
typedef KIFTestStepResult (^KIFTestExecutionBlock)(NSError **error);

/*!
 @typedef KIFTestCompletionBlock
 @param result The result of the test, either KIFTestStepResultSuccess or KIFTestStepResultFailure.
 @param error An error provided by the test or nil if result is equal to KIFTestStepResultSuccess.
 */
typedef void (^KIFTestCompletionBlock)(KIFTestStepResult result, NSError *error);

@protocol KIFTesterDelegate;

@interface KIFTester : NSObject

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line;

@property (nonatomic, readonly) NSString *file;
@property (nonatomic, readonly) NSInteger line;
@property (nonatomic, assign) id<KIFTesterDelegate> delegate;

- (void)runBlock:(KIFTestExecutionBlock)executionBlock complete:(KIFTestCompletionBlock)completionBlock timeout:(NSTimeInterval)timeout;
- (void)runBlock:(KIFTestExecutionBlock)executionBlock complete:(KIFTestCompletionBlock)completionBlock;
- (void)runBlock:(KIFTestExecutionBlock)executionBlock timeout:(NSTimeInterval)timeout;
- (void)runBlock:(KIFTestExecutionBlock)executionBlock;

@end

@protocol KIFTesterDelegate <NSObject>

- (void)failWithException:(NSException *)exception;

@end