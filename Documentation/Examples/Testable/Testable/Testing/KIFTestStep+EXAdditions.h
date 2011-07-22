//
//  KIFTestStep+EXAdditions.h
//  Testable
//
//  Created by Eric Firestone on 6/13/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>
#import "KIFTestStep.h"

@interface KIFTestStep (EXAdditions)

// Factory Steps

+ (id)stepToReset;

// Step Collections

// Assumes the application was reset and sitting at the welcome screen
+ (NSArray *)stepsToGoToLoginPage;

@end
