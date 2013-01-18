//
//  KIFTester.h
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>
#import "KIFTestStep.h"

@protocol KIFTesterDelegate;

@interface KIFTester : NSObject

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line;

@property (nonatomic, readonly) NSString *file;
@property (nonatomic, readonly) NSInteger line;
@property (nonatomic, assign) id<KIFTesterDelegate> delegate;

- (KIFTestStepResult)run:(KIFTestStep *)step;
- (KIFTestStepResult)runBlock:(KIFTestStepExecutionBlock)block;

@end

@protocol KIFTesterDelegate <NSObject>

- (void)failWithException:(NSException *)exception;

@end