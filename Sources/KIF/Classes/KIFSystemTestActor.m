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
#import "UIAutomationHelper.h"


@implementation KIFSystemTestActor

- (NSNotification *)waitForNotificationName:(NSString*)name object:(id)object
{
    return [self waitForNotificationName:name object:object whileExecutingBlock:nil];
}

- (NSNotification *)waitForNotificationName:(NSString *)name object:(id)object whileExecutingBlock:(void(^)(void))block
{
    return [self waitForNotificationName:name object:object whileExecutingBlock:block complete:nil];
}

- (NSNotification *)waitForNotificationName:(NSString *)name object:(id)object whileExecutingBlock:(void(^)(void))block complete:(void(^)(void))complete
{
    __block NSNotification *detectedNotification = nil;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        detectedNotification = note;
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
    
    return detectedNotification;
}

- (void)simulateMemoryWarning
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

- (void)simulateDeviceRotationToOrientation:(UIDeviceOrientation)orientation
{
#ifdef __IPHONE_16_0
    if (@available(iOS 16.0, *)) {
        NSSet<UIScene *> *scenes = [[UIApplication sharedApplication] connectedScenes];
        UIWindowScene* windowScene;
        for (UIScene* scene in scenes) {
            if([scene isKindOfClass:[UIWindowScene class]]) {
                windowScene = (UIWindowScene*) scene;
                break;
            }
        }
        
        if (windowScene) {
            UIInterfaceOrientationMask orientationMask;
            switch (orientation) {
                case UIDeviceOrientationUnknown:
                    orientationMask = UIInterfaceOrientationMaskAll;
                    break;
                case UIDeviceOrientationPortrait:
                    orientationMask = UIInterfaceOrientationMaskPortrait;
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    orientationMask = UIInterfaceOrientationMaskPortraitUpsideDown;
                    break;
                case UIDeviceOrientationLandscapeLeft:
                    orientationMask = UIInterfaceOrientationMaskLandscapeLeft;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    orientationMask = UIInterfaceOrientationMaskLandscapeRight;
                    break;
                case UIDeviceOrientationFaceUp:
                    orientationMask = UIInterfaceOrientationMaskAll;
                    break;
                case UIDeviceOrientationFaceDown:
                    orientationMask = UIInterfaceOrientationMaskAll;
                    break;
            }
            
            UIWindowSceneGeometryPreferencesIOS* preferences = [[UIWindowSceneGeometryPreferencesIOS alloc]initWithInterfaceOrientations:orientationMask];
            [windowScene requestGeometryUpdateWithPreferences:preferences errorHandler:^(NSError * _Nonnull error) {
                [self failWithError:[NSError KIFErrorWithUnderlyingError:error format:@"Could not rotate the screen"] stopTest:YES];
            }];
        }
    } else {
#endif
        [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
#ifdef __IPHONE_16_0
    }
#endif
}


- (void)waitForApplicationToOpenAnyURLWhileExecutingBlock:(void (^)(void))block returning:(BOOL)returnValue
{
    [self waitForApplicationToOpenURL:nil whileExecutingBlock:block returning:returnValue];
}

- (void)waitForApplicationToOpenURLWithScheme:(NSString *)URLScheme whileExecutingBlock:(void (^)(void))block returning:(BOOL)returnValue {
    [self waitForApplicationToOpenURLMatchingBlock:^(NSURL *actualURL){
        if (URLScheme && ![URLScheme isEqualToString:actualURL.scheme]) {
            [self failWithError:[NSError KIFErrorWithFormat:@"Expected %@ to start with %@", actualURL.absoluteString, URLScheme] stopTest:YES];
        }
    } whileExecutingBlock:block returning:returnValue];
}

- (void)waitForApplicationToOpenURL:(NSString *)URLString whileExecutingBlock:(void (^)(void))block returning:(BOOL)returnValue {
    [self waitForApplicationToOpenURLMatchingBlock:^(NSURL *actualURL){

        if (URLString && ![[actualURL absoluteString] isEqualToString:URLString]) {
            [self failWithError:[NSError KIFErrorWithFormat:@"Expected %@, got %@", URLString, actualURL.absoluteString] stopTest:YES];
        }
    } whileExecutingBlock:block returning:returnValue];
}

- (void)waitForApplicationToOpenURLMatchingBlock:(void (^)(NSURL *actualURL))URLMatcherBlock whileExecutingBlock:(void (^)(void))block returning:(BOOL)returnValue
{
    [UIApplication startMockingOpenURLWithReturnValue:returnValue];

    id canOpenURLObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidMockCanOpenURLNotification object:[UIApplication sharedApplication] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        if (URLMatcherBlock) {
            NSURL *actualURL = [notification.userInfo objectForKey:UIApplicationOpenedURLKey];
            URLMatcherBlock(actualURL);
        }
    }];

    NSNotification *notification = [self waitForNotificationName:UIApplicationDidMockOpenURLNotification object:[UIApplication sharedApplication] whileExecutingBlock:block complete:^{
        [UIApplication stopMockingOpenURL];
        [[NSNotificationCenter defaultCenter] removeObserver:canOpenURLObserver];
    }];

    if (URLMatcherBlock) {
        NSURL *actualURL = [notification.userInfo objectForKey:UIApplicationOpenedURLKey];
        URLMatcherBlock(actualURL);
    }
}

- (void)captureScreenshotWithDescription:(NSString *)description
{
    NSError *error;
    if (![[UIApplication sharedApplication] writeScreenshotForLine:(NSUInteger)self.line inFile:self.file description:description error:&error]) {
        [self failWithError:error stopTest:NO];
    }
}

- (void)deactivateAppForDuration:(NSTimeInterval)duration {
    [UIAutomationHelper deactivateAppForDuration:@(duration)];
}

@end
