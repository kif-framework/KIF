//
//  KIFLogger.m
//  KIF
//
//  Created by Fahim Farook on 10/3/13.
//
//

#import "KIFLogger.h"
#import "KIFTestScenario.h"
#import "NSFileManager-KIFAdditions.h"
#import "KIFTestController.h"

@interface KIFLogger ()

@property (nonatomic, retain) NSFileHandle *fileHandle;
@property (nonatomic, retain) NSString *filePath;

@end

@implementation KIFLogger

#define KIFLog(...) [[self logFileHandle] writeData:[[NSString stringWithFormat:@"%@\n", [NSString stringWithFormat:__VA_ARGS__]] dataUsingEncoding:NSUTF8StringEncoding]]; NSLog(__VA_ARGS__);
#define KIFLogBlankLine() KIFLog(@" ");
#define KIFLogSeparator() KIFLog(@"---------------------------------------------------");

-(NSFileHandle *)logFileHandle {
    if (!_fileHandle) {
		NSFileManager *fm = [NSFileManager defaultManager];
		if (!_logDirectory) {
			NSString *dir = [fm createUserDirectory:NSLibraryDirectory];
			if (dir) {
				self.logDirectory = [dir stringByAppendingPathComponent:@"logs"];
			}
		}
        if (![fm recursivelyCreateDirectory:_logDirectory]) {
            self.logDirectory = nil;
        }
		if (!_fileExt) {
			self.fileExt = @"log";
		}
		if (!_logFile) {
			NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterLongStyle];
			dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"."];
			dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
			self.logFile = [NSString stringWithFormat:@"KIF Tests %@.%@", dateString, _fileExt];
		}
        self.filePath = [_logDirectory stringByAppendingPathComponent:_logFile];
        if (![fm fileExistsAtPath:_filePath]) {
            [fm createFileAtPath:_filePath contents:[NSData data] attributes:nil];
        }
        self.fileHandle = [[NSFileHandle fileHandleForWritingAtPath:_filePath] retain];
    }
    return _fileHandle;
}

-(void)logTestingDidStart {
	NSFileHandle *fh = [self logFileHandle];
	if (fh) {
		NSLog(@"Logging KIF test activity to %@", _filePath);
	}
    if (_controller.failedScenarioIndexes.count != _controller.scenarios.count) {
        KIFLog(@"BEGIN KIF TEST RUN: re-running %d of %d scenarios that failed last time", _controller.failedScenarioIndexes.count, _controller.scenarios.count);
    } else {
        KIFLog(@"BEGIN KIF TEST RUN: %d scenarios", _controller.scenarios.count);
    }
}

-(void)logTestingDidFinish {
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLog(@"KIF TEST RUN FINISHED: %d failures (duration %.2fs)", _controller.failureCount, -[_controller.testSuiteStartDate timeIntervalSinceNow]);
    KIFLogSeparator();
	[_fileHandle closeFile];
	[_fileHandle release];
	self.fileHandle = nil;
    // Also log the failure count to stdout, for easier integration with CI tools.
    NSLog(@"*** KIF TESTING FINISHED: %d failures", _controller.failureCount);
}

-(void)logDidStartScenario:(KIFTestScenario *)scenario {
    KIFLogBlankLine();
    KIFLogSeparator();
    KIFLog(@"BEGIN SCENARIO %d/%d (%d steps)", [_controller.scenarios indexOfObjectIdenticalTo:scenario] + 1, _controller.scenarios.count, scenario.steps.count);
    KIFLog(@"%@", scenario.description);
    KIFLogSeparator();
}

-(void)logDidSkipScenario:(KIFTestScenario *)scenario {
    if ([[[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_SILENT_FILTERING"] boolValue]) return; // Don't want filter skipping noise
    KIFLogBlankLine();
    KIFLogSeparator();
    NSString *reason = (scenario.skippedByFilter ? @"filter doesn't match description" : @"only running previously-failed scenarios");
    KIFLog(@"SKIPPING SCENARIO %d/%d (%@)", [_controller.scenarios indexOfObjectIdenticalTo:scenario] + 1, _controller.scenarios.count, reason);
    KIFLog(@"%@", scenario.description);
    KIFLogSeparator();
}

-(void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString {
    KIFLog(@"Skipping scenario generator %@ because it takes arguments", selectorString);
}

-(void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration {
    KIFLogSeparator();
    KIFLog(@"END OF SCENARIO (duration %.2fs)", duration);
    KIFLogSeparator();
}

-(void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error {
    KIFLog(@"FAIL (%.2fs): %@", duration, step);
    KIFLog(@"FAILING ERROR: %@", error);
}

-(void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration {
    KIFLog(@"PASS (%.2fs): %@", duration, step);
}

@end
