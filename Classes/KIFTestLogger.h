//
//  KIFTestLogger.h
//  KIF
//
//  Created by Rodney Gomes on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFTestController.h"
#import "KIFTestScenario.h"
#import "KIFTestStep.h"
#import "KIFTestLogger.h"

@interface KIFTestLogger : NSObject {
    KIFTestController* controller;
}

@property (nonatomic,retain) KIFTestController *controller;

- (void) setupController: (KIFTestController*) controller;

- (void)logTestingDidStart;

- (void)logTestingDidFinish;

- (void)logDidStartScenario:(KIFTestScenario *)scenario;

- (void)logDidSkipScenario:(KIFTestScenario *)scenario;

- (void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString;

- (void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration;

- (void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;

- (void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;

@end
