//
//  KIFTestController.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "KIFTestController.h"
#import "KIFTestScenario.h"
#import "KIFTestStep.h"


@interface KIFTestController ()

@property (nonatomic, retain) KIFTestScenario *currentScenario;
@property (nonatomic, retain) KIFTestStep *currentStep;
@property (nonatomic, retain) NSArray *scenarios;
@property (nonatomic, getter=isTesting) BOOL testing;
@property (nonatomic, retain) NSDate *currentStepStartDate;
@property (nonatomic, copy) KIFTestControllerCompletionBlock completionBlock;

- (void)_initializeScenariosIfNeeded;
- (void)_scheduleCurrentTestStep;
- (void)_performTestStep:(KIFTestStep *)step;
- (void)_advanceWithResult:(KIFTestStepResult)result error:(NSError*) error;
- (KIFTestStep *)_nextStep;
- (KIFTestScenario *)_nextScenario;
- (void)_logTestingDidStart;
- (void)_logTestingDidFinish;
- (void)_logDidFailStep:(KIFTestStep *)step;
- (void)_logDidPassStep:(KIFTestStep *)step;
- (void)_logDidStartScenario:(KIFTestScenario *)scenario;

@end


@implementation KIFTestController

@synthesize scenarios;
@synthesize testing;
@synthesize failureCount;
@synthesize currentScenario;
@synthesize currentStep;
@synthesize currentStepStartDate;
@synthesize completionBlock;

#pragma mark Static Methods

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
    
    return self;
}

- (void)dealloc;
{
    self.scenarios = nil;
    self.currentStepStartDate = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (void)initializeScenarios;
{
    // For subclassers
}

- (NSArray *)scenarios
{
    [self _initializeScenariosIfNeeded];
    return scenarios;
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
    
    self.testing = YES;
    self.currentScenario = (self.scenarios.count ? [self.scenarios objectAtIndex:0] : nil);
    self.currentStep = (self.currentScenario.steps.count ? [self.currentScenario.steps objectAtIndex:0] : nil);
    self.currentStepStartDate = [NSDate date];
    self.completionBlock = inCompletionBlock;
    
    [self _logTestingDidStart];
    [self _logDidStartScenario:self.currentScenario];
    
    [self _scheduleCurrentTestStep];
}

- (void)_testingDidFinish
{
    [self _logTestingDidFinish];
    self.testing = NO;
    self.completionBlock();
}

#pragma mark Private Methods

- (void)_initializeScenariosIfNeeded
{
    if (!scenarios) {
        self.scenarios = [NSMutableArray array];
        [self initializeScenarios];
    }
}

- (void)_scheduleCurrentTestStep;
{
    [self performSelector:@selector(_scheduleCurrentTestStepAfterDelay) withObject:nil afterDelay:0.01f];
}

- (void)_scheduleCurrentTestStepAfterDelay;
{
    [self _performTestStep:self.currentStep];
}

- (void)_performTestStep:(KIFTestStep *)step;
{
    NSError *error = nil;
    
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
    
    switch (result) {
        case KIFTestStepResultFailure: {
            [self _logDidFailStep:self.currentStep];
            self.currentScenario = [self _nextScenario];
            self.currentStep = (self.currentScenario.steps.count ? [self.currentScenario.steps objectAtIndex:0] : nil);
            self.currentStepStartDate = [NSDate date];
            if (error) {
                NSLog(@"The step \"%@\" failed: %@", self.currentStep, [error description]);
            }
            failureCount++;
            break;
        }
        case KIFTestStepResultSuccess: {
            [self _logDidPassStep:self.currentStep];
            self.currentStep = [self _nextStep];
            if (!self.currentStep) {
                self.currentScenario = [self _nextScenario];
                self.currentStep = (self.currentScenario.steps.count ? [self.currentScenario.steps objectAtIndex:0] : nil);
            }
            self.currentStepStartDate = [NSDate date];
            break;
        }
        case KIFTestStepResultWait: {
            // Don't do anything; the current step will be scheduled for execution again.
            // If there's a timeout, then fail
            if ([self.currentStepStartDate timeIntervalSinceNow] < -self.currentStep.timeout) {
                NSLog(@"The step \"%@\" timed out after %f seconds", self.currentStep, self.currentStep.timeout);
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

- (KIFTestScenario *)_nextScenario;
{
    NSUInteger currentScenarioIndex = [self.scenarios indexOfObjectIdenticalTo:self.currentScenario];
    NSAssert(currentScenarioIndex != NSNotFound, @"Current scenario %@ not found in test scenarios %@, but should be!", self.currentScenario, self.scenarios);
    
    NSUInteger nextScenarioIndex = currentScenarioIndex + 1;
    KIFTestScenario *nextScenario = nil;
    if ([self.scenarios count] > nextScenarioIndex) {
        nextScenario = [self.scenarios objectAtIndex:nextScenarioIndex];
    }
    
    if (nextScenario) {
        [self _logDidStartScenario:nextScenario];
    }
    
    return nextScenario;    
}

- (void)_logTestingDidStart;
{
    NSLog(@"*** TESTING STARTED");
}

- (void)_logTestingDidFinish;
{
    NSLog(@"*** TESTING FINISHED: %d failures", failureCount);
}

- (void)_logDidFailStep:(KIFTestStep *)step;
{
    NSLog(@"FAIL: %@", step);    
}

- (void)_logDidPassStep:(KIFTestStep *)step;
{
    NSLog(@"PASS: %@", step);
}

- (void)_logDidStartScenario:(KIFTestScenario *)scenario;
{
    NSLog(@"*** SCENARIO: %@", scenario.description);
}

@end
