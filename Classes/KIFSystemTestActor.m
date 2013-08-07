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

- (NSNotification *)waitForNotificationName:(NSString*)name object:(id)object
{
    return [self waitForNotificationName:name object:object whileExecutingBlock:nil];
}

- (NSNotification *)waitForNotificationName:(NSString *)name object:(id)object whileExecutingBlock:(void(^)())block
{
    __block NSNotification *detectedNotification = nil;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [detectedNotification release];
        detectedNotification = [note retain];
    }];
    
    if (block) {
        block();
    }
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition(detectedNotification, error, @"Waiting for notification \"%@\"", name);
        return KIFTestStepResultSuccess;
    } complete:^(KIFTestStepResult result, NSError *error) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    
    return [detectedNotification autorelease];
}

- (void)simulateMemoryWarning
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

@end
