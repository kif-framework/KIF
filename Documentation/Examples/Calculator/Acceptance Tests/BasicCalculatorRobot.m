//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

@import KIF;

#import "BasicCalculatorRobot.h"


@implementation BasicCalculatorRobot

#pragma mark - Public Methods

- (void)enterValue1:(NSString *)value1 value2:(NSString *)value2 operation:(NSString *)operation
{
    [self enterValue1:value1];
    [self enterValue2:value2];
    [self setOperation:operation];
}

- (void)enterValue1:(NSString *)value
{
    [[viewTester usingLabel:@"First Number"] clearAndEnterText:value];
}

- (void)enterValue2:(NSString *)value
{
    [[viewTester usingLabel:@"Second Number"] clearAndEnterText:value];
}

- (void)setOperation:(NSString *)operation
{
    // A segmented control labels each of its segments with the title it displays, so the segment
    // for an operation is found by its operator. Tests read better when they name the operation
    // instead, which makes the robot the place where those two vocabularies meet.
    NSDictionary<NSString *, NSString *> *operatorsByOperation = @{
        @"Add": @"+",
        @"Subtract": @"–",
        @"Multiply": @"×",
        @"Divide": @"÷",
    };

    NSString *operatorTitle = operatorsByOperation[operation];
    NSAssert(operatorTitle != nil, @"Unknown operation (%@)", operation);

    [[viewTester usingLabel:operatorTitle] tap];
}

- (void)waitForResult:(NSString *)result
{
    [[viewTester usingLabel:result] waitForView];
}

@end


BasicCalculatorRobot *basicCalculatorRobot(KIFTestCase *testCase)
{
    return [[BasicCalculatorRobot alloc] initWithTestCase:testCase];
}
