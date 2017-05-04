//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFUITestActor+BasicCalculator.h"


@implementation KIFUITestActor (BasicCalculator)

- (void)enterValue1:(NSString *)value
{
    [self clearTextFromAndThenEnterText:value intoViewWithAccessibilityLabel:@"First Number"];
}

- (void)enterValue2:(NSString *)value
{
    [self clearTextFromAndThenEnterText:value intoViewWithAccessibilityLabel:@"Second Number"];
}

- (void)setOperation:(NSString *)operation
{
    [self tapViewWithAccessibilityLabel:operation];
}

- (void)enterValue1:(NSString *)value1 value2:(NSString *)value2 operation:(NSString *)operation
{
    [self enterValue1:value1];
    [self enterValue2:value2];
    [self setOperation:operation];
}

- (void)waitForResult:(NSString *)result
{
    [self waitForViewWithAccessibilityLabel:result];
}

@end
