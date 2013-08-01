//
//  KIFTester.m
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestActor.h"
#import "NSError-KIFAdditions.h"
#import <SenTestingKit/SenTestingKit.h>
#import <dlfcn.h>
#import <objc/runtime.h>

@implementation KIFTestActor

+ (void)load
{
    @autoreleasepool {
        NSLog(@"KIFTester loaded");
        [KIFTestActor _enableAccessibility];
        
        if ([[NSProcessInfo processInfo] environment][@"StartKIFManually"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SenTestToolKey];
            SenSelfTestMain();
        }
    }
}

+ (void)_enableAccessibility;
{
    NSString *appSupportLocation = @"/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport";
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *simulatorRoot = [environment objectForKey:@"IPHONE_SIMULATOR_ROOT"];
    if (simulatorRoot) {
        appSupportLocation = [simulatorRoot stringByAppendingString:appSupportLocation];
    }
    
    void *appSupportLibrary = dlopen([appSupportLocation fileSystemRepresentation], RTLD_LAZY);
    
    CFStringRef (*copySharedResourcesPreferencesDomainForDomain)(CFStringRef domain) = dlsym(appSupportLibrary, "CPCopySharedResourcesPreferencesDomainForDomain");
    
    if (copySharedResourcesPreferencesDomainForDomain) {
        CFStringRef accessibilityDomain = copySharedResourcesPreferencesDomainForDomain(CFSTR("com.apple.Accessibility"));
        
        if (accessibilityDomain) {
            CFPreferencesSetValue(CFSTR("ApplicationAccessibilityEnabled"), kCFBooleanTrue, accessibilityDomain, kCFPreferencesAnyUser, kCFPreferencesAnyHost);
            CFRelease(accessibilityDomain);
        }
    }
}

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate
{
    self = [super init];
    if (self) {
        _file = [file retain];
        _line = line;
        _delegate = delegate;
        _executionBlockTimeout = [[self class] defaultTimeout];
    }
    return self;
}

+ (instancetype)actorInFile:(NSString *)file atLine:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate
{
    return [[[self alloc] initWithFile:file line:line delegate:delegate] autorelease];
}

- (instancetype)usingTimeout:(NSTimeInterval)executionBlockTimeout
{
    self.executionBlockTimeout = executionBlockTimeout;
    return self;
}

- (void)runBlock:(KIFTestExecutionBlock)executionBlock complete:(KIFTestCompletionBlock)completionBlock timeout:(NSTimeInterval)timeout
{
    NSDate *startDate = [NSDate date];
    KIFTestStepResult result;
    NSError *error = nil;
    
    while ((result = executionBlock(&error)) == KIFTestStepResultWait && -[startDate timeIntervalSinceNow] < timeout) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    if (result == KIFTestStepResultWait) {
        error = [NSError KIFErrorWithUnderlyingError:error format:@"The step timed out after %.2f seconds: %@", timeout, error.localizedDescription];
        result = KIFTestStepResultFailure;
    }
    
    if (completionBlock) {
        completionBlock(result, error);
    }
    
    if (result == KIFTestStepResultFailure) {
        [self failWithError:error stopTest:YES];
    }
}

- (void)runBlock:(KIFTestExecutionBlock)executionBlock complete:(KIFTestCompletionBlock)completionBlock
{
    [self runBlock:executionBlock complete:completionBlock timeout:self.executionBlockTimeout];
}

- (void)runBlock:(KIFTestExecutionBlock)executionBlock timeout:(NSTimeInterval)timeout
{
    [self runBlock:executionBlock complete:nil timeout:timeout];
}

- (void)runBlock:(KIFTestExecutionBlock)executionBlock
{
    [self runBlock:executionBlock complete:nil];
}

- (void)dealloc
{
    [_file release];
    [super dealloc];
}

#pragma mark Class Methods

static NSTimeInterval KIFTestStepDefaultTimeout = 10.0;

+ (NSTimeInterval)defaultTimeout;
{
    return KIFTestStepDefaultTimeout;
}

+ (void)setDefaultTimeout:(NSTimeInterval)newDefaultTimeout;
{
    KIFTestStepDefaultTimeout = newDefaultTimeout;
}

#pragma mark Generic tests

- (void)fail
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestCondition(NO, error, @"This test always fails");
    }];
}

- (void)failWithError:(NSError *)error stopTest:(BOOL)stopTest
{
    [self.delegate failWithException:[NSException failureInFile:self.file atLine:self.line withDescription:error.localizedDescription] stopTest:stopTest];
}

- (void)waitForTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition((([NSDate timeIntervalSinceReferenceDate] - startTime) >= timeInterval), error, @"Waiting for time interval to expire.");
        return KIFTestStepResultSuccess;
    } timeout:timeInterval + 1];
}

@end

@implementation KIFTestActor (Delegate)

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    [self.delegate failWithException:exception stopTest:YES];
}

@end
