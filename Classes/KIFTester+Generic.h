//
//  KIFTester+Generic.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTester.h"

@interface KIFTester (Generic)

- (void)succeed;
- (void)fail;

- (void)waitForTimeInterval:(NSTimeInterval)timeInterval;
- (void)waitForNotificationName:(NSString*)name object:(id)object;
- (void)waitForNotificationName:(NSString *)name object:(id)object whileExecutingStep:(KIFTestStep *)childStep;

- (void)simulateMemoryWarning;

- (void)giveUpOnAllTestsAndRunAppForever;

@end
