//
//  KIFTestStep+EXAdditions.h
//  Testable
//
//  Created by Eric Firestone on 6/13/11.
//  Copyright 2011 Square Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KIF/KIFTestStep.h>

@interface KIFTestStep (EXAdditions)

// Factory Steps

+ (id)stepToReset;

// Step Collections

// Assumes the application was reset and sitting at the welcome screen
+ (NSArray *)stepsToGoToLoginPage;

@end
