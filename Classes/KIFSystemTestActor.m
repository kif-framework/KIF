//
//  KIFTester+Generic.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFSystemTestActor.h"
#import <UIKit/UIKit.h>

@implementation KIFSystemTestActor

- (void)waitForNotificationName:(NSString*)name object:(id)object
{
    [self waitForNotificationName:name object:object whileExecutingBlock:nil];
}

- (void)waitForNotificationName:(NSString *)name object:(id)object whileExecutingBlock:(void(^)())block
{
    __block BOOL notificationOccurred = NO;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        notificationOccurred = YES;
    }];
    
    if (block) {
        block();
    }
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition(notificationOccurred, error, @"Waiting for notification \"%@\"", name);
        return KIFTestStepResultSuccess;
    } complete:^(KIFTestStepResult result, NSError *error) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}

- (void)simulateMemoryWarning
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

@end
