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

@interface KIFTestScenario ()

@property (nonatomic, readwrite, retain) NSArray *steps;
@property (nonatomic, readwrite) BOOL skippedByFilter;

- (void)_initializeStepsIfNeeded;

@end

@implementation KIFTestScenario

@synthesize description;
@synthesize steps;
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

#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)dealloc
{
    self.steps = nil;
    self.description = nil;
    
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
    [steps addObject:step];
}

- (void)addStepsFromArray:(NSArray *)inSteps;
{
    for (KIFTestStep *step in inSteps) {
        NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    }
    
    [self _initializeStepsIfNeeded];
    [steps addObjectsFromArray:inSteps];
}

#pragma mark Private Methods

- (void)_initializeStepsIfNeeded
{
    if (!steps && !self.skippedByFilter) {
        self.steps = [NSMutableArray array];
        [self initializeSteps];
    }
}

@end
