//
//  KIFTester+Generic.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTester+Generic.h"

@implementation KIFTester (Generic)

- (void)succeed
{
    [self run:[KIFTestStep stepThatSucceeds]];
}

- (void)fail
{
    [self run:[KIFTestStep stepThatFails]];
}

- (void)waitForTimeInterval:(NSTimeInterval)timeInterval
{
    NSString *description = [NSString stringWithFormat:@"Waiting %f seconds", timeInterval];
    
    [self run:[KIFTestStep stepToWaitForTimeInterval:timeInterval description:description]];
}

- (void)waitForNotificationName:(NSString*)name object:(id)object
{
    [self run:[KIFTestStep stepToWaitForNotificationName:name object:object]];
}

- (void)waitForNotificationName:(NSString *)name object:(id)object whileExecutingStep:(KIFTestStep *)childStep
{
    [self run:[KIFTestStep stepToWaitForNotificationName:name object:object whileExecutingStep:childStep]];
}

- (void)simulateMemoryWarning
{
    [self run:[KIFTestStep stepToSimulateMemoryWarning]];
}

- (void)giveUpOnAllTestsAndRunAppForever
{
    [self waitForTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]];
}



@end
