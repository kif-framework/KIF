//
//  EXTestController.m
//  Testable
//
//  Created by Eric Firestone on 6/3/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "EXTestController.h"
#import "KIFTestScenario+EXAdditions.h"
#import "KIFJUnitLogger.h"

@implementation EXTestController

-(id)init {
	self = [super init];
	if (self) {
		// Add JUNit logger
		KIFJUnitLogger *logger = [[KIFJUnitLogger alloc] init];
		logger.logDirectory = @"/Users/fahim/Public/logs";
		[self addLogger:logger];
	}
	return self;
}

-(void)initializeScenarios; {
    // If your app is doing anything interesting with parameterized scenarios,
    // you'll want to override this method and add them manually.
//    [self addScenario:[KIFTestScenario scenarioToLogin]];
//    [self addScenario:[KIFTestScenario scenarioToSelectDifferentColors]];
    
    // If you're not, 
    [super initializeScenarios];
}

@end
