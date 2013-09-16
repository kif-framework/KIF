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
#import "UIApplication-KIFAdditions.h"
#import "NSError-KIFAdditions.h"

@interface UIApplication (Private)
- (BOOL)rotateIfNeeded:(UIDeviceOrientation)orientation;
@end

@implementation KIFSystemTestActor

- (NSNotification *)waitForNotificationName:(NSString*)name object:(id)object
{
    return [self waitForNotificationName:name object:object whileExecutingBlock:nil];
}

- (NSNotification *)waitForNotificationName:(NSString *)name object:(id)object whileExecutingBlock:(void(^)())block
{
    return [self waitForNotificationName:name object:object whileExecutingBlock:block complete:nil];
}

- (NSNotification *)waitForNotificationName:(NSString *)name object:(id)object whileExecutingBlock:(void(^)())block complete:(void(^)())complete
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
        
        if (complete) {
            complete();
        }
    }];
    
    return [detectedNotification autorelease];
}

- (void)simulateMemoryWarning
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

- (void)simulateDeviceRotationToOrientation:(UIDeviceOrientation)orientation
{
    [[UIApplication sharedApplication] rotateIfNeeded:orientation];
}

- (void)waitForApplicationToOpenAnyURLWhileExecutingBlock:(void (^)())block returning:(BOOL)returnValue
{
    [self waitForApplicationToOpenURL:nil whileExecutingBlock:block returning:returnValue];
}

- (void)waitForApplicationToOpenURL:(NSString *)URLString whileExecutingBlock:(void (^)())block returning:(BOOL)returnValue
{
    [UIApplication startMockingOpenURLWithReturnValue:returnValue];
    NSNotification *notification = [self waitForNotificationName:UIApplicationDidMockOpenURLNotification object:[UIApplication sharedApplication] whileExecutingBlock:block complete:^{
        [UIApplication stopMockingOpenURL];
    }];
    
    NSString *actualURLString = [[notification.userInfo objectForKey:UIApplicationOpenedURLKey] absoluteString];
    if (URLString && ![URLString isEqualToString:actualURLString]) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Expected %@, got %@", URLString, actualURLString] stopTest:YES];
    }
}

- (void)captureScreenshotWithDescription:(NSString *)description
{
    NSError *error;
    if (![[UIApplication sharedApplication] writeScreenshotForLine:(NSUInteger)self.line inFile:self.file description:description error:&error]) {
        [self failWithError:error stopTest:NO];
    }
}

@end
