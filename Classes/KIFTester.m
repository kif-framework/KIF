//
//  KIFTester.m
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTester.h"
#import <SenTestingKit/SenTestingKit.h>
#import <dlfcn.h>
#import <objc/runtime.h>

@implementation KIFTester

+ (void)load
{
    @autoreleasepool {
        NSLog(@"KIFTester loaded");
        [KIFTester _enableAccessibility];
        
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

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line
{
    self = [super init];
    if (self) {
        _file = [file retain];
        _line = line;
    }
    return self;
}

- (KIFTestStepResult)run:(KIFTestStep *)step
{
    NSDate *startDate = [NSDate date];
    
    KIFTestStepResult result;
    NSError *error;
    
    while ((result = [step executeAndReturnError:&error]) == KIFTestStepResultWait && -[startDate timeIntervalSinceNow] < step.timeout) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    if (result == KIFTestStepResultSuccess) {
        return result;
    }
    
    if (result == KIFTestStepResultWait) {
        NSDictionary *userInfo = @{NSUnderlyingErrorKey: error, NSLocalizedDescriptionKey: [NSString stringWithFormat:@"The step timed out after %.2f seconds: %@", step.timeout, error.localizedDescription]};
        error = [NSError errorWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:userInfo];
    }
    
    [self.delegate failWithException:[NSException failureInFile:self.file atLine:self.line withDescription:error.localizedDescription]];
    
    return KIFTestStepResultFailure;
}

- (KIFTestStepResult)runBlock:(KIFTestStepExecutionBlock)block
{
    return [self run:[KIFTestStep stepWithDescription:@"KIFTester generated block" executionBlock:block]];
}

- (void)dealloc
{
    [_file release];
    [super dealloc];
}

@end
