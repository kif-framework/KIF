//
//  KIFTestStep.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "KIFTestStep.h"


@interface KIFTestStep ()

@property (nonatomic, copy) KIFTestStepExecutionBlock executionBlock;

@end


@implementation KIFTestStep

@synthesize description;
@synthesize executionBlock;
@synthesize timeout;

#pragma mark Static Methods

+ (id)stepWithDescription:(NSString *)description executionBlock:(KIFTestStepExecutionBlock)executionBlock;
{
    NSAssert(description.length, @"All steps must have a description");
    NSAssert(executionBlock, @"A custom step cannot be created with an execution block");
    
    KIFTestStep *step = [[self alloc] init];
    step.description = description;
    step.executionBlock = executionBlock;
    return [step autorelease];
}

+ (id)stepThatFails;
{
    return [self stepWithDescription:@"Always fails" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        KIFTestCondition(NO, error, @"This test always fails");
    }];
}

+ (id)stepThatSucceeds;
{
    return [self stepWithDescription:@"Always succeeds" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        return KIFTestStepResultSuccess;
    }];
}

+ (void)stepFailed;
{
    // Add a logging call here or set a breakpoint to debug failed KIFTestCondition calls
}


#pragma mark Initialization

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.timeout = 30.0f;
    
    return self;
}

- (void)dealloc;
{
    [executionBlock release];
    executionBlock = nil;
    [description release];
    description = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (KIFTestStepResult)executeAndReturnError:(NSError **)error
{
    KIFTestStepResult result = KIFTestStepResultFailure;
    
    if (self.executionBlock) {
        @try {
            result = self.executionBlock(self, error);
        }
        @catch (id exception) {
            // We need to catch exceptions and things like NSInternalInconsistencyException, which is actually an NSString
            KIFTestCondition(NO, error, @"Step threw exception: %@", exception);
        }
    }
    
    return result;
}

@end
