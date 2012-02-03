//
//  KIFJunitTestLogger.h
//  KIF
//
//  Created by Rodney Gomes on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFTestLogger.h"
#import "NSFileManager-KIFAdditions.h"

@interface KIFJunitTestLogger : KIFTestLogger {
    NSFileHandle* fileHandle;
}

@property (nonatomic, retain) NSFileHandle *fileHandle;
@property (nonatomic, retain) NSString *logDirectoryPath;

- (void)logTestingDidStart;

- (void)logTestingDidFinish;

- (void)logDidStartScenario:(KIFTestScenario *)scenario;

- (void)logDidSkipScenario:(KIFTestScenario *)scenario;

- (void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString;

- (void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration;

- (void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;

- (void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;

@end
