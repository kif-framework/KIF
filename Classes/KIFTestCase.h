//
//  KIFTestCase.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <SenTestingKit/SenTestingKit.h>
#import "SenTestCase-KIFAdditions.h"

@interface KIFTestCase : SenTestCase

- (void)beforeAll;
- (void)beforeEach;
- (void)afterEach;
- (void)afterAll;

@property (nonatomic, assign) BOOL stopTestsOnFirstBigFailure;

@end

