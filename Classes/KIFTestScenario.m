//
//  KIFTestScenario.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "KIFTestScenario.h"
#import "KIFTestStep.h"

@interface KIFTestScenario ()

@property (nonatomic, retain) NSArray *steps;

- (void)_initializeStepsIfNeeded;

@end

@implementation KIFTestScenario

@synthesize description;
@synthesize steps;

#pragma mark Static Methods

+ (id)scenarioWithDescription:(NSString *)description
{
    KIFTestScenario *scenario = [[self alloc] init];
    scenario.description = description;
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
    if (!steps) {
        self.steps = [NSMutableArray array];
        [self initializeSteps];
    }
}

@end
