//
//  KIFJunitTestLogger.m
//  KIF
//
//  Created by Rodney Gomes on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFJunitTestLogger.h"

@implementation KIFJunitTestLogger

@synthesize fileHandle;
@synthesize logDirectoryPath;

static NSMutableDictionary* durations = nil;
static NSMutableDictionary* errors = nil;
static KIFTestScenario* currentScenario = nil;

- (void)initFileHandle;
{
    if (!fileHandle) {
        NSString *logsDirectory;
        if (!self.logDirectoryPath) {
            logsDirectory = [[NSFileManager defaultManager] createUserDirectory:NSLibraryDirectory];
            if (logsDirectory) {
                logsDirectory = [logsDirectory stringByAppendingPathComponent:@"Logs"];
            }
        }
        else{
            logsDirectory = self.logDirectoryPath;
        }

        
        if (![[NSFileManager defaultManager] recursivelyCreateDirectory:logsDirectory]) {
            logsDirectory = nil;
        }
        
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle 
                                                              timeStyle:NSDateFormatterLongStyle];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"."];
        dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
        NSString *fileName = [NSString stringWithFormat:@"KIF Tests %@.junit.xml", dateString];
        
        NSString *logFilePath = [logsDirectory stringByAppendingPathComponent:fileName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
            [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:[NSData data] attributes:nil];
        }
        
        fileHandle = [[NSFileHandle fileHandleForWritingAtPath:logFilePath] retain];
        
        if (fileHandle) {
            NSLog(@"JUNIT XML RESULTS AT %@", logFilePath);
        }
    }
}

- (void)appendToLog:(NSString*) data;
{
    [self initFileHandle];
    [self.fileHandle writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc;
{
    [fileHandle closeFile];
    [fileHandle release];
    self.logDirectoryPath = nil;
    [errors release];
    [durations release];
    [super dealloc];
}


- (void)_init;
{
    if (durations == nil) {
        durations = [[NSMutableDictionary alloc] init];
    }
    
    if (errors == nil) { 
        errors = [[NSMutableDictionary alloc] init];
    }
}

- (void)logTestingDidStart;
{
    [self _init]; 
}

- (void)logTestingDidFinish;
{
    NSTimeInterval totalDuration = -[self.controller.testSuiteStartDate timeIntervalSinceNow];
    NSString* data = [NSString stringWithFormat: @"<testsuite name=\"%@\" tests=\"%d\" failures=\"%d\" time=\"%0.4f\">\n",
                      @"KIF Tests", [self.controller.scenarios count], self.controller.failureCount, totalDuration];
    
    [self appendToLog:data];
    
    for (KIFTestScenario* scenario in self.controller.scenarios) { 
        NSNumber* duration = [durations objectForKey: [scenario description]];
        NSError* error = [errors objectForKey: [scenario description]];
        
        
        NSString* scenarioSteps = [[scenario.steps valueForKeyPath:@"description"] componentsJoinedByString:@"\n"];
        NSString* errorMsg =  (error ? [NSString stringWithFormat:@"<failure message=\"%@\">%@</failure>", 
                                        [error localizedDescription], scenarioSteps] :
                               @"");
        
        NSString* description = [scenario description];
        NSString* classString = NSStringFromClass([scenario class]);
        
        data = [NSString stringWithFormat:@"<testcase name=\"%@\" class=\"%@\" time=\"%0.4f\">%@</testcase>\n",
                                          description, classString, [duration doubleValue], errorMsg];
        [self appendToLog:data];
    }
        
    [self appendToLog:@"</testsuite>\n"];
}

- (void)logDidStartScenario:(KIFTestScenario *)scenario;
{
    currentScenario = scenario;
}

- (void)logDidSkipScenario:(KIFTestScenario *)scenario;
{

}

- (void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString;
{
    
}

- (void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration;
{
    NSNumber* number = [[NSNumber alloc] initWithDouble: duration];
    [durations setValue: number forKey: [scenario description]];
}

- (void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;
{
    [errors setValue:error forKey:[currentScenario description]];
}

- (void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;
{
    
}

@end
