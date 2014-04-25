//
//  KIFTester.h
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>

#ifdef DEPRECATED_MSG_ATTRIBUTE
#define KIF_DEPRECATED(m) DEPRECATED_MSG_ATTRIBUTE(m)
#else
#define KIF_DEPRECATED(m)
#endif

#define KIFActorWithClass(clazz) [clazz actorInFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__ delegate:self]

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
typedef NS_ENUM(NSUInteger, KIFTestStepResult) {
    KIFTestStepResultFailure = 0,
    KIFTestStepResultSuccess,
    KIFTestStepResultWait,
};

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

@protocol KIFTestActorDelegate;

@interface KIFTestActor : NSObject

+ (instancetype)actorInFile:(NSString *)file atLine:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;

@property (strong, nonatomic, readonly) NSString *file;
@property (nonatomic, readonly) NSInteger line;
@property (weak, nonatomic, readonly) id<KIFTestActorDelegate> delegate;
@property (nonatomic) NSTimeInterval executionBlockTimeout;

- (instancetype)usingTimeout:(NSTimeInterval)executionBlockTimeout;

- (void)runBlock:(KIFTestExecutionBlock)executionBlock complete:(KIFTestCompletionBlock)completionBlock timeout:(NSTimeInterval)timeout;
- (void)runBlock:(KIFTestExecutionBlock)executionBlock complete:(KIFTestCompletionBlock)completionBlock;
- (void)runBlock:(KIFTestExecutionBlock)executionBlock timeout:(NSTimeInterval)timeout;
- (void)runBlock:(KIFTestExecutionBlock)executionBlock;

/*!
 @method defaultTimeout
 @abstract The default amount of time to assign to execution blocks before assuming they failed.
 @discussion To change the default value of the timeout property, call +setDefaultTimeout: with a different value.
 */
+ (NSTimeInterval)defaultTimeout;

/*!
 @method setDefaultTimeout:
 @abstract Sets the default amount of time to assign to execution blocks before assuming they failed.
 */
+ (void)setDefaultTimeout:(NSTimeInterval)newDefaultTimeout;

/*!
 @abstract Fails the test.
 @discussion Mostly useful for test debugging or as a placeholder when building new tests.
 */
- (void)fail;

- (void)failWithError:(NSError *)error stopTest:(BOOL)stopTest;

/*!
 @abstract Waits for a certain amount of time before returning.
 @discussion In general when waiting for the app to get into a known state, it's better to use -waitForTappableViewWithAccessibilityLabel:, however this step may be useful in some situations as well.
 @param interval The number of seconds to wait before returning.
 */
- (void)waitForTimeInterval:(NSTimeInterval)timeInterval;

@end

@protocol KIFTestActorDelegate <NSObject>

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop;
- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop;

@end

@interface KIFTestActor (Delegate) <KIFTestActorDelegate>
@end
