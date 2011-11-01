//
//  KIFTestScenario.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestScenario.h"
#import "KIFTestStep.h"


static NSArray *defaultStepsToSetUp = nil;
static NSArray *defaultStepsToTearDown = nil;


@interface KIFTestScenario ()

@property (nonatomic, readwrite, retain) NSArray *steps;
@property (nonatomic, readwrite) BOOL skippedByFilter;

- (void)_initializeStepsIfNeeded;

@end


@implementation KIFTestScenario

@synthesize description;
@synthesize steps;
@synthesize stepsToSetUp;
@synthesize stepsToTearDown;
@synthesize skippedByFilter;

#pragma mark Static Methods

+ (id)scenarioWithDescription:(NSString *)description
{
    KIFTestScenario *scenario = [[self alloc] init];
    scenario.description = description;
    NSString *filter = [[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_SCENARIO_FILTER"];
    if (filter) {
        scenario.skippedByFilter = ([description rangeOfString:filter options:NSRegularExpressionSearch].location == NSNotFound);
    }
    
    return [scenario autorelease];
}

+ (void)setDefaultStepsToSetUp:(NSArray *)steps;
{
    if (defaultStepsToSetUp == steps) {
        return;
    }
    
    [defaultStepsToSetUp release];
    defaultStepsToSetUp = [steps copy];
}

+ (NSArray *)defaultStepsToSetUp;
{
    return defaultStepsToSetUp;
}

+ (void)setDefaultStepsToTearDown:(NSArray *)steps;
{
    if (defaultStepsToTearDown == steps) {
        return;
    }
    
    [defaultStepsToTearDown release];
    defaultStepsToTearDown = [steps copy];
}

+ (NSArray *)defaultStepsToTearDown;
{
    return defaultStepsToTearDown;
}

#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    stepsToSetUp = [defaultStepsToSetUp copy];
    stepsToTearDown = [defaultStepsToTearDown copy];
    
    return self;
}

- (void)dealloc
{
    [steps release]; steps = nil;
    [stepsToSetUp release]; stepsToSetUp = nil;
    [stepsToTearDown release]; stepsToTearDown = nil;
    [description release]; description = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (void)initializeSteps;
{
    // For subclasses
}

- (NSArray *)steps;
{
    [self _initializeStepsIfNeeded];
    return steps;
}

- (void)addStep:(KIFTestStep *)step;
{
    NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    
    [self _initializeStepsIfNeeded];
    [steps insertObject:step atIndex:(steps.count - self.stepsToTearDown.count)];
}

- (void)addStepsFromArray:(NSArray *)inSteps;
{
    for (KIFTestStep *step in inSteps) {
        NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    }
    
    [self _initializeStepsIfNeeded];
    [steps insertObjects:inSteps atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(steps.count - self.stepsToTearDown.count, inSteps.count)]];
}

- (void)setStepsToSetUp:(NSArray *)inStepsToSetUp;
{
    if ([stepsToSetUp isEqual:inStepsToSetUp]) {
        return;
    }
    
    // Remove the old set up steps and add the new ones
    // If steps hasn't been set up yet, that's fine
    [steps removeObjectsInRange:NSMakeRange(0, stepsToSetUp.count)];
    [steps insertObjects:inStepsToSetUp atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, inStepsToSetUp.count)]];
    
    [stepsToSetUp release];
    stepsToSetUp = [inStepsToSetUp copy];
}

- (void)setStepsToTearDown:(NSArray *)inStepsToTearDown;
{
    if ([stepsToTearDown isEqual:inStepsToTearDown]) {
        return;
    }
        
    // Remove the old tear down steps and add the new ones
    // If steps hasn't been set up yet, that's fine
    [steps removeObjectsInRange:NSMakeRange(steps.count - stepsToTearDown.count, stepsToTearDown.count)];
    [steps insertObjects:inStepsToTearDown atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(steps.count, inStepsToTearDown.count)]];
    
    [stepsToTearDown release];
    stepsToTearDown = [inStepsToTearDown copy];
}

#pragma mark Private Methods

- (void)_initializeStepsIfNeeded;
{
    if (!steps && !self.skippedByFilter) {
        NSMutableArray *initialSteps = [NSMutableArray arrayWithArray:self.stepsToSetUp];
        [initialSteps addObjectsFromArray:self.stepsToTearDown];
        self.steps = initialSteps;
        [self initializeSteps];
    }
}

@end
