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
#if Z2_APPLE
#import <QuartzCore/QuartzCore.h>
#endif
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

//Z2Live Addition
//Stores information on failedScenarios for end of testrun output
@property (nonatomic, retain) NSMutableArray* failedScenarios;

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
@synthesize failedScenarios = _failedScenarios;

#pragma mark Static Methods


//Z2Live Addition: Some KIF tests can load an explanation on what it means if a KIF test has failed at a specific location, which will help external users debug the workflow.
static NSString* inCaseOfFailureString;
static NSString* lastKIFLogStep;


+ (void)load
{
    [KIFTestController _enableAccessibility];
}

+ (void)_enableAccessibility;
{
    #if !Z2_ANDROID
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
    #endif  
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
    //TODOANDROID: Commenting Assert to make compile
    // NSAssert(![self.scenarios containsObject:scenario], @"The scenario %@ is already added", scenario);
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
    //TODOANDROID: Commenting Assert to make compile
    // NSAssert((!self.currentStep || result == KIFTestStepResultSuccess || error), @"The step \"%@\" returned a non-successful result but did not include an error", self.currentStep.description);
    
    KIFTestStep *previousStep = self.currentStep;
    NSTimeInterval currentStepDuration = -[self.currentStepStartDate timeIntervalSinceNow];
    
    switch (result) {
        case KIFTestStepResultFailure: {
            if(!self.currentStep.skipFailureLogging)
            {
                [self _logDidFailStep:self.currentStep duration:currentStepDuration error:error];
                [self _writeScreenshotForStep:self.currentStep];
                failureCount++;
            }
            [self.currentStep cleanUp];
            
            self.currentScenario = [self _nextScenarioAfterResult:result];
            self.currentScenarioStartDate = [NSDate date];
            self.currentStep = (self.currentScenario.steps.count ? [self.currentScenario.steps objectAtIndex:0] : nil);
            self.currentStepStartDate = [NSDate date];
                        
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
                if(self.currentStep.succeedOnTimeout)
                {
                    [self _advanceWithResult:KIFTestStepResultSuccess error:nil];
                }
                else
                {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:error, NSUnderlyingErrorKey, [NSString stringWithFormat:@"The step timed out after %.2f seconds.", self.currentStep.timeout], NSLocalizedDescriptionKey, nil];
                    error = [NSError errorWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:userInfo];
                    [self _advanceWithResult:KIFTestStepResultFailure error:error];
                }
            }
            break;
        }
    }
    //TODOANDROID: Commenting Assert to make compile
    // NSAssert(!self.currentStep || self.currentStep.description.length, @"The step following the step \"%@\" is missing a description", previousStep.description);
}

- (KIFTestStep *)_nextStep;
{
    NSArray *steps = self.currentScenario.steps;
    NSUInteger currentStepIndex = [steps indexOfObjectIdenticalTo:self.currentStep];
    //TODOANDROID: Commenting Assert to make compile
    // NSAssert(currentStepIndex != NSNotFound, @"Current step %@ not found in current scenario %@, but should be!", self.currentStep, self.currentScenario);
    
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
        //TODOANDROID: Commenting Assert to make compile
        // NSAssert(currentScenarioIndex != NSNotFound, @"Current scenario %@ not found in test scenarios %@, but should be!", self.currentScenario, self.scenarios);
        
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
    //TODOANDROID: ScreenshotForStep
#if !Z2_ANDROID
    NSString *outputPath = [[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_SCREENSHOTS"];
    if (!outputPath) {
        return;
    }
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    if (windows.count == 0) {
        return;
    }
    
    //Z2Live Addition: Ensure directory is created
    [[NSFileManager defaultManager] createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:nil];
    
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
#endif
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
    
    //Z2Live Addition: Output failing scenarios
    if(failureCount)
    {
        KIFLog(@"KIF TEST RUN FINISHED: PRINTING %d FAILURES", failureCount);
        for(NSDictionary* failedScenario in self.failedScenarios)
        {
            [self _printDidFailScenarioIndex:[failedScenario objectForKey:@"scenarioIndex"]
                             withDescription:[failedScenario objectForKey:@"scenarioDesc"]
                                withDuration:[failedScenario objectForKey:@"duration"]
                              withFailedStep:[failedScenario objectForKey:@"scenarioStep"]
                                   withError:[failedScenario objectForKey:@"stepError"]
                                 withLastLog:[failedScenario objectForKey:@"lastKIFLogStep"]
             ];
        }
    }
    
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

//Z2Live Modification: This is an override of KIFTestController's failure handling in order to improve readability on fail
- (void)_logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;
{
    NSNumber* indexOfFailedTest = [NSNumber numberWithInt:[self.scenarios indexOfObjectIdenticalTo:self->currentScenario] + 1 ];
    NSString* failedScenarioDescription = [NSString stringWithString:[self->currentScenario description]];
    NSNumber* stepDuration = [NSNumber numberWithDouble:duration];
    NSString* failedScenarioStep = [NSString stringWithString:[step description]];
    NSString* failingError = [NSString stringWithString:[error localizedDescription]];
    
    //Take the last logged message, which is either the scenario description or an actual logged step
    NSString* lastKIFTestLog = nil;
    if(lastKIFLogStep)
        lastKIFTestLog = [NSString stringWithString:lastKIFLogStep];
    else
        lastKIFTestLog = failedScenarioDescription;
    
    if(inCaseOfFailureString)
    {
        lastKIFTestLog = [NSString stringWithFormat:@"\n%@ \nPossible Explanation for failure is: %@", lastKIFTestLog, inCaseOfFailureString];
        //We release the original inCaseOfFailureString because it should only apply once. We have to release it now because the unload step will not be reached through normal flow, we have already failed the scenario.
        [KIFTestController unloadInCaseOfFailureMessage];
    }
    
    [self _printDidFailScenarioIndex:indexOfFailedTest withDescription:failedScenarioDescription withDuration:stepDuration withFailedStep:failedScenarioStep withError:failingError withLastLog:lastKIFTestLog];
    
    if(self.failedScenarios == nil)
        self.failedScenarios = [[NSMutableArray alloc] init];
    
    [self.failedScenarios addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               indexOfFailedTest, @"scenarioIndex",
                                               failedScenarioDescription, @"scenarioDesc",
                                               stepDuration, @"duration",
                                               failedScenarioStep, @"scenarioStep",
                                               failingError, @"stepError",
                                               lastKIFTestLog, @"lastKIFLogStep",
                                               nil
                                               ]];
}

//Z2Live Addition: Expand information presented on scenario failure
- (void)_printDidFailScenarioIndex:(NSNumber*)index withDescription:(NSString*)scenarioDescription withDuration:(NSNumber*)duration withFailedStep:(NSString*)step withError:(NSString*)error withLastLog:(NSString*)lastKIFTestLog;
{
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLogSeparator();
    KIFLogBlankLine();
    KIFLog(@"THE FAILED SCENARIO:");
    KIFLog(@"SCENARIO %d/%d", [index intValue], [[self scenarios] count]);
    KIFLog(@"SCENARIO DESCRIPTION: %@", scenarioDescription);
    KIFLogBlankLine();
    KIFLog(@"FAIL STEP (%.2fs): %@", [duration doubleValue], step);
    KIFLog(@"FAILING ERROR: %@", error);
    KIFLog(@"LAST USER DEFINED STEP LOG: %@", lastKIFTestLog);
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLogSeparator();
    KIFLogBlankLine();
}

- (void)_logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;
{
    KIFLog(@"PASS (%.2fs): %@", duration, step);
}

+ (void)debugLog:(NSString *)message
{
    NSLog(@"KIF Step Log: %@", message);
    if(lastKIFLogStep != nil)
        [lastKIFLogStep autorelease];
    
    lastKIFLogStep = [message retain];
}

+ (void)loadInCaseOfFailureMessage:(NSString*)message
{
    inCaseOfFailureString = [message retain];
}

+ (void)unloadInCaseOfFailureMessage
{
    if(inCaseOfFailureString != nil)
    {
        [inCaseOfFailureString release];
        inCaseOfFailureString = nil;
    }
}

@end
