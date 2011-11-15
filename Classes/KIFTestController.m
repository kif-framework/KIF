//
//  KIFTestController.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestController.h"
#import "KIFTestScenario.h"
#import "KIFTestStep.h"
#import "NSFileManager-KIFAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import <dlfcn.h>
#import <objc/runtime.h>


extern id objc_msgSend(id theReceiver, SEL theSelector, ...);


@interface KIFTestController ()

@property (nonatomic, retain) KIFTestScenario *currentScenario;
@property (nonatomic, retain) KIFTestStep *currentStep;
@property (nonatomic, retain) NSArray *scenarios;
@property (nonatomic, getter=isTesting) BOOL testing;
@property (nonatomic, retain) NSDate *testSuiteStartDate;
@property (nonatomic, retain) NSDate *currentScenarioStartDate;
@property (nonatomic, retain) NSDate *currentStepStartDate;
@property (nonatomic, copy) KIFTestControllerCompletionBlock completionBlock;

+ (void)_enableAccessibility;

- (void)_initializeScenariosIfNeeded;
- (BOOL)_isAccessibilityInspectorEnabled;
- (void)_scheduleCurrentTestStep;
- (void)_performTestStep:(KIFTestStep *)step;
- (void)_advanceWithResult:(KIFTestStepResult)result error:(NSError*) error;
- (KIFTestStep *)_nextStep;
- (KIFTestScenario *)_nextScenarioAfterResult:(KIFTestStepResult)result;
- (void)_writeScreenshotForStep:(KIFTestStep *)step;
- (void)_logTestingDidStart;
- (void)_logTestingDidFinish;
- (void)_logDidStartScenario:(KIFTestScenario *)scenario;
- (void)_logDidSkipScenario:(KIFTestScenario *)scenario;
- (void)_logDidSkipAddingScenarioGenerator:(NSString *)selectorString;
- (void)_logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration;
- (void)_logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;
- (void)_logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;

@end


@implementation KIFTestController

@synthesize scenarios;
@synthesize testing;
@synthesize testSuiteStartDate;
@synthesize failureCount;
@synthesize currentScenario;
@synthesize currentStep;
@synthesize currentScenarioStartDate;
@synthesize currentStepStartDate;
@synthesize completionBlock;

#pragma mark Static Methods

+ (void)load
{
    [KIFTestController _enableAccessibility];
}

+ (void)_enableAccessibility;
{
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
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
    
    [autoreleasePool drain];
}

static KIFTestController *sharedInstance = nil;

static void releaseInstance()
{
    [sharedInstance release];
    sharedInstance = nil;
}

+ (id)sharedInstance;
{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        atexit(releaseInstance);
    });
    
    return sharedInstance;
}

#pragma mark Initialization Methods

- (id)init;
{
    NSAssert(!sharedInstance, @"KIFTestController should not be initialized manually. Use +sharedInstance instead.");
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSString *failedScenarioPath = [[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_FAILURE_FILE"];
    if (failedScenarioPath) {
        failedScenarioFile = [[NSURL fileURLWithPath:failedScenarioPath] retain];
        failedScenarioIndexes = [[NSKeyedUnarchiver unarchiveObjectWithFile:failedScenarioPath] mutableCopy];
    }
    if (!failedScenarioIndexes) {
        failedScenarioIndexes = [[NSMutableIndexSet alloc] init];
    }
    
    return self;
}

- (void)dealloc;
{
    self.currentStep = nil;
    self.currentScenario = nil;
    self.scenarios = nil;
    self.testSuiteStartDate = nil;
    self.currentScenarioStartDate = nil;
    self.currentStepStartDate = nil;
    self.completionBlock = nil;
    
    [failedScenarioFile release];
    failedScenarioFile = nil;

    [failedScenarioIndexes release];
    failedScenarioIndexes = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (void)initializeScenarios;
{
    [self addAllScenarios];
}

- (NSArray *)scenarios
{
    [self _initializeScenariosIfNeeded];
    return scenarios;
}

- (void)addAllScenarios;
{
    [self addAllScenariosWithSelectorPrefix:@"scenario" fromClass:[KIFTestScenario class]];
}

- (void)addAllScenariosWithSelectorPrefix:(NSString *)selectorPrefix fromClass:(Class)klass;
{
    unsigned int count;
    Method *methods = class_copyMethodList(object_getClass(klass), &count);
    
    if (!count) {
        return;
    }
    
    NSMutableArray *selectorStrings = [NSMutableArray array];

    for (NSInteger index = 0; index < count; index++) {
        SEL selector = method_getName(methods[index]);
        NSString *selectorString = NSStringFromSelector(selector);
        if ([selectorString hasPrefix:selectorPrefix]) {
            if ([selectorString hasSuffix:@":"]) {
                if (![selectorString isEqualToString:@"scenarioWithDescription:"]) {
                    // Logging about -scenarioWithDescription: would just be noise.
                    // But log that we're skipping the rest to not confuse people who would expect their scenario to get run automatically.
                    [self _logDidSkipAddingScenarioGenerator:selectorString];
                }
                continue;
            }
            
            [selectorStrings addObject:selectorString];
        }
    }
    
    [selectorStrings sortUsingSelector:@selector(compare:)];
    [selectorStrings enumerateObjectsUsingBlock:^(id selectorString, NSUInteger idx, BOOL *stop) {
        KIFTestScenario *scenario = (KIFTestScenario *)objc_msgSend(klass, NSSelectorFromString(selectorString));
        [self addScenario:scenario];
    }];
    
    free(methods);
}

- (void)addScenario:(KIFTestScenario *)scenario;
{
    NSAssert(![self.scenarios containsObject:scenario], @"The scenario %@ is already added", scenario);
    NSAssert(scenario.description.length, @"Cannot add a scenario that does not have a description");
    
    [self _initializeScenariosIfNeeded];
    [scenarios addObject:scenario];
}

- (void)startTestingWithCompletionBlock:(KIFTestControllerCompletionBlock)inCompletionBlock
{
    NSAssert(!self.testing, @"Testing is already in progress");
    NSAssert([self _isAccessibilityInspectorEnabled], @"The accessibility inspector must be enabled in order to run KIF tests. It can be turned on in the Settings app of the simulator by going to General -> Accessibility.");
    
    self.testing = YES;
    self.testSuiteStartDate = [NSDate date];

    if (!failedScenarioIndexes.count && self.scenarios.count) {
        [failedScenarioIndexes addIndexesInRange:NSMakeRange(0, self.scenarios.count)];
    }

    [self _logTestingDidStart];

    self.currentScenario = [self _nextScenarioAfterResult:KIFTestStepResultSuccess];
    self.currentScenarioStartDate = [NSDate date];
    self.currentStep = (self.currentScenario.steps.count ? [self.currentScenario.steps objectAtIndex:0] : nil);
    self.currentStepStartDate = [NSDate date];
    self.completionBlock = inCompletionBlock;
    
    [self _scheduleCurrentTestStep];
}

- (void)_testingDidFinish
{
    [self _logTestingDidFinish];
    self.testing = NO;
    
    if (failedScenarioFile) {
        [NSKeyedArchiver archiveRootObject:failedScenarioIndexes toFile:[failedScenarioFile path]];
    }
    
    if (self.completionBlock) {
        self.completionBlock();
    }
}

#pragma mark Private Methods

- (void)_initializeScenariosIfNeeded
{
    if (!scenarios) {
        self.scenarios = [NSMutableArray array];
        [self initializeScenarios];
    }
}

- (BOOL)_isAccessibilityInspectorEnabled;
{
    // This method for testing if the inspector is enabled was taken from the Frank framework.
    // https://github.com/moredip/Frank
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    NSString *originalAccessibilityLabel = [keyWindow accessibilityLabel];
    
    [keyWindow setAccessibilityLabel:@"KIF Test Label"];
    BOOL isInspectorEnabled = [[keyWindow accessibilityLabel] isEqualToString:@"KIF Test Label"];
    
    [keyWindow setAccessibilityLabel:originalAccessibilityLabel];
    
    return isInspectorEnabled;
}

- (void)_scheduleCurrentTestStep;
{
    [self performSelector:@selector(_delayedScheduleCurrentTestStep) withObject:nil afterDelay:0.01f];
}

- (void)_delayedScheduleCurrentTestStep;
{
    [self _performTestStep:self.currentStep];
}

- (void)_performTestStep:(KIFTestStep *)step;
{
    NSError *error = nil;
    
    if (!step) {
        [self _testingDidFinish];
        return;
    }
    
    KIFTestStepResult result = [step executeAndReturnError:&error];
    
    [self _advanceWithResult:result error:error];
    
    if (self.currentStep) {
        [self _scheduleCurrentTestStep];
    } else {
        [self _testingDidFinish];
    }
}

- (void)_advanceWithResult:(KIFTestStepResult)result error:(NSError *)error;
{
    NSAssert((!self.currentStep || result == KIFTestStepResultSuccess || error), @"The step \"%@\" returned a non-successful result but did not include an error", self.currentStep.description);
    
    KIFTestStep *previousStep = self.currentStep;
    NSTimeInterval currentStepDuration = -[self.currentStepStartDate timeIntervalSinceNow];
    
    switch (result) {
        case KIFTestStepResultFailure: {
            [self _logDidFailStep:self.currentStep duration:currentStepDuration error:error];
            [self _writeScreenshotForStep:self.currentStep];
            [self.currentStep cleanUp];
            
            self.currentScenario = [self _nextScenarioAfterResult:result];
            self.currentScenarioStartDate = [NSDate date];
            self.currentStep = (self.currentScenario.steps.count ? [self.currentScenario.steps objectAtIndex:0] : nil);
            self.currentStepStartDate = [NSDate date];
            failureCount++;
            break;
        }
        case KIFTestStepResultSuccess: {
            [self _logDidPassStep:self.currentStep duration:currentStepDuration];
            [self.currentStep cleanUp];
            
            self.currentStep = [self _nextStep];
            if (!self.currentStep) {
                self.currentScenario = [self _nextScenarioAfterResult:result];
                self.currentScenarioStartDate = [NSDate date];
                self.currentStep = (self.currentScenario.steps.count ? [self.currentScenario.steps objectAtIndex:0] : nil);
            }
            self.currentStepStartDate = [NSDate date];
            break;
        }
        case KIFTestStepResultWait: {
            // Don't do anything; the current step will be scheduled for execution again.
            // If there's a timeout, then fail.
            if (currentStepDuration > self.currentStep.timeout) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:error, NSUnderlyingErrorKey, [NSString stringWithFormat:@"The step timed out after %.2f seconds.", self.currentStep.timeout], NSLocalizedDescriptionKey, nil];
                error = [NSError errorWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:userInfo];
                [self _advanceWithResult:KIFTestStepResultFailure error:error];
            }
            break;
        }
    }
    
    NSAssert(!self.currentStep || self.currentStep.description.length, @"The step following the step \"%@\" is missing a description", previousStep.description);
}

- (KIFTestStep *)_nextStep;
{
    NSArray *steps = self.currentScenario.steps;
    NSUInteger currentStepIndex = [steps indexOfObjectIdenticalTo:self.currentStep];
    NSAssert(currentStepIndex != NSNotFound, @"Current step %@ not found in current scenario %@, but should be!", self.currentStep, self.currentScenario);
    
    NSUInteger nextStepIndex = currentStepIndex + 1;
    KIFTestStep *nextStep = nil;
    if ([steps count] > nextStepIndex) {
        nextStep = [steps objectAtIndex:nextStepIndex];
    }
    
    return nextStep;
}

- (KIFTestScenario *)_nextScenarioAfterResult:(KIFTestStepResult)result;
{
    if (!self.scenarios.count) {
        return nil;
    }
    
    KIFTestScenario *nextScenario = nil;
    NSUInteger nextScenarioIndex = NSNotFound;
    NSUInteger currentScenarioIndex = NSNotFound;
    NSInteger scenarioLimit = [[[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_SCENARIO_LIMIT"] integerValue];
    
    if (scenarioLimit > 0 && completeScenarioCount++ >= scenarioLimit) {
        return nil;
    } else if (result == KIFTestStepResultFailure && [[[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_EXIT_ON_FAILURE"] boolValue]) {
        return nil;
    } else if (self.currentScenario) {
        currentScenarioIndex = [self.scenarios indexOfObjectIdenticalTo:self.currentScenario];
        NSAssert(currentScenarioIndex != NSNotFound, @"Current scenario %@ not found in test scenarios %@, but should be!", self.currentScenario, self.scenarios);
        
        [self _logDidFinishScenario:self.currentScenario duration:-[self.currentScenarioStartDate timeIntervalSinceNow]];
        if (result == KIFTestStepResultSuccess) {
            [failedScenarioIndexes removeIndex:currentScenarioIndex];
        }

        nextScenarioIndex = [failedScenarioIndexes indexGreaterThanIndex:currentScenarioIndex];
        currentScenarioIndex++;
    } else {
        currentScenarioIndex = [[[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_INITIAL_SKIP_COUNT"] integerValue];
        nextScenarioIndex = MAX([failedScenarioIndexes firstIndex], currentScenarioIndex);
    }
    
    do {
        for (; currentScenarioIndex < nextScenarioIndex && currentScenarioIndex < [self.scenarios count]; currentScenarioIndex++) {
            [self _logDidSkipScenario:[self.scenarios objectAtIndex:currentScenarioIndex]];
        }
        
        if ([self.scenarios count] > nextScenarioIndex) {
            nextScenario = [self.scenarios objectAtIndex:nextScenarioIndex];
            if (nextScenario.skippedByFilter) {
                [self _logDidSkipScenario:nextScenario];
                [failedScenarioIndexes removeIndex:nextScenarioIndex];
            }
        } else {
            nextScenario = nil;
        }
        currentScenarioIndex = nextScenarioIndex + 1;
        nextScenarioIndex = [failedScenarioIndexes indexGreaterThanIndex:nextScenarioIndex];
    } while (nextScenario && nextScenario.skippedByFilter);
    
    if (nextScenario) {
        [self _logDidStartScenario:nextScenario];
    }
    
    return nextScenario;
}

- (void)_writeScreenshotForStep:(KIFTestStep *)step;
{
    NSString *outputPath = [[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_SCREENSHOTS"];
    if (!outputPath) {
        return;
    }
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    if (windows.count == 0) {
        return;
    }
    
    UIGraphicsBeginImageContext([[windows objectAtIndex:0] bounds].size);
    for (UIWindow *window in windows) {
        [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    outputPath = [outputPath stringByExpandingTildeInPath];
    outputPath = [outputPath stringByAppendingPathComponent:[step.description stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    outputPath = [outputPath stringByAppendingPathExtension:@"png"];
    [UIImagePNGRepresentation(image) writeToFile:outputPath atomically:YES];
}

#pragma mark Logging

#define KIFLog(...) [[self _logFileHandleForWriting] writeData:[[NSString stringWithFormat:@"%@\n", [NSString stringWithFormat:__VA_ARGS__]] dataUsingEncoding:NSUTF8StringEncoding]]; NSLog(__VA_ARGS__);
#define KIFLogBlankLine() KIFLog(@" ");
#define KIFLogSeparator() KIFLog(@"---------------------------------------------------");

- (NSFileHandle *)_logFileHandleForWriting;
{
    static NSFileHandle *fileHandle = nil;
    if (!fileHandle) {
        NSString *logsDirectory = [[NSFileManager defaultManager] createUserDirectory:NSLibraryDirectory];
        
        if (logsDirectory) {
            logsDirectory = [logsDirectory stringByAppendingPathComponent:@"Logs"];
        }
        if (![[NSFileManager defaultManager] recursivelyCreateDirectory:logsDirectory]) {
            logsDirectory = nil;
        }
        
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterLongStyle];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"."];
        dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
        NSString *fileName = [NSString stringWithFormat:@"KIF Tests %@.log", dateString];
        
        NSString *logFilePath = [logsDirectory stringByAppendingPathComponent:fileName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
            [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:[NSData data] attributes:nil];
        }
        
        fileHandle = [[NSFileHandle fileHandleForWritingAtPath:logFilePath] retain];
        
        if (fileHandle) {
            NSLog(@"Logging KIF test activity to %@", logFilePath);
        }
    }
    
    return fileHandle;
}

- (void)_logTestingDidStart;
{
    if (failedScenarioIndexes.count != self.scenarios.count) {
        KIFLog(@"BEGIN KIF TEST RUN: re-running %d of %d scenarios that failed last time", failedScenarioIndexes.count, self.scenarios.count);
    } else {
        KIFLog(@"BEGIN KIF TEST RUN: %d scenarios", self.scenarios.count);
    }
}

- (void)_logTestingDidFinish;
{
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLog(@"KIF TEST RUN FINISHED: %d failures (duration %.2fs)", failureCount, -[self.testSuiteStartDate timeIntervalSinceNow]);
    KIFLogSeparator();
    
    // Also log the failure count to stdout, for easier integration with CI tools.
    NSLog(@"*** KIF TESTING FINISHED: %d failures", failureCount);
}

- (void)_logDidStartScenario:(KIFTestScenario *)scenario;
{
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLog(@"BEGIN SCENARIO %d/%d (%d steps)", [self.scenarios indexOfObjectIdenticalTo:scenario] + 1, self.scenarios.count, scenario.steps.count);
    KIFLog(@"%@", scenario.description);
    KIFLogSeparator();
}

- (void)_logDidSkipScenario:(KIFTestScenario *)scenario;
{
    KIFLogBlankLine();
    KIFLogSeparator();
    NSString *reason = (scenario.skippedByFilter ? @"filter doesn't match description" : @"only running previously-failed scenarios");
    KIFLog(@"SKIPPING SCENARIO %d/%d (%@)", [self.scenarios indexOfObjectIdenticalTo:scenario] + 1, self.scenarios.count, reason);
    KIFLog(@"%@", scenario.description);
    KIFLogSeparator();
}

- (void)_logDidSkipAddingScenarioGenerator:(NSString *)selectorString;
{
    KIFLog(@"Skipping scenario generator %@ because it takes arguments", selectorString);
}

- (void)_logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration
{
    KIFLogSeparator();
    KIFLog(@"END OF SCENARIO (duration %.2fs)", duration);
    KIFLogSeparator();
}

- (void)_logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;
{
    KIFLog(@"FAIL (%.2fs): %@", duration, step);
    KIFLog(@"FAILING ERROR: %@", error);
}

- (void)_logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;
{
    KIFLog(@"PASS (%.2fs): %@", duration, step);
}

@end
