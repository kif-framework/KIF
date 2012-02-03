//
//  KIFTestLogger.m
//  KIF
//
//  Created by Rodney Gomes on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFTestLogger.h"
#import "NSFileManager-KIFAdditions.h"

@implementation KIFTestLogger

@synthesize controller;

- (void)setupController: (KIFTestController*) theController;
{
    self.controller = theController;
}

#define KIFLog(...) [[self logFileHandleForWriting] writeData:[[NSString stringWithFormat:@"%@\n", [NSString stringWithFormat:__VA_ARGS__]] dataUsingEncoding:NSUTF8StringEncoding]]; NSLog(__VA_ARGS__);
#define KIFLogBlankLine() KIFLog(@" ");
#define KIFLogSeparator() KIFLog(@"---------------------------------------------------");

- (NSFileHandle *)logFileHandleForWriting;
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

- (void)logTestingDidStart;
{
    if (self.controller.failureCount != self.controller.scenarios.count) {
        KIFLog(@"BEGIN KIF TEST RUN: re-running %d of %d scenarios that failed last time", self.controller.failureCount,self.controller.scenarios.count);
    } else {
        KIFLog(@"BEGIN KIF TEST RUN: %d scenarios", self.controller.scenarios.count);
    }
}

- (void)logTestingDidFinish;
{
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLog(@"KIF TEST RUN FINISHED: %d failures (duration %.2fs)", self.controller.failureCount, -[self.controller.testSuiteStartDate timeIntervalSinceNow]);
    KIFLogSeparator();
    
    // Also log the failure count to stdout, for easier integration with CI tools.
    NSLog(@"*** KIF TESTING FINISHED: %d failures", self.controller.failureCount);
}

- (void)logDidStartScenario:(KIFTestScenario *)scenario;
{
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLog(@"BEGIN SCENARIO %d/%d (%d steps)", [self.controller.scenarios indexOfObjectIdenticalTo:scenario] + 1, self.controller.scenarios.count, scenario.steps.count);
    KIFLog(@"%@", scenario.description);
    KIFLogSeparator();
}

- (void)logDidSkipScenario:(KIFTestScenario *)scenario;
{
    KIFLogBlankLine();
    KIFLogSeparator();
    NSString *reason = (scenario.skippedByFilter ? @"filter doesn't match description" : @"only running previously-failed scenarios");
    KIFLog(@"SKIPPING SCENARIO %d/%d (%@)", [self.controller.scenarios indexOfObjectIdenticalTo:scenario] + 1, self.controller.scenarios.count, reason);
    KIFLog(@"%@", scenario.description);
    KIFLogSeparator();
}

- (void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString;
{
    KIFLog(@"Skipping scenario generator %@ because it takes arguments", selectorString);
}

- (void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration
{
    KIFLogSeparator();
    KIFLog(@"END OF SCENARIO (duration %.2fs)", duration);
    KIFLogSeparator();
}

- (void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;
{
    KIFLog(@"FAIL (%.2fs): %@", duration, step);
    KIFLog(@"FAILING ERROR: %@", error);
}

- (void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;
{
    KIFLog(@"PASS (%.2fs): %@", duration, step);
}

@end
