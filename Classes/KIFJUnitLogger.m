//
//  KIFJUnitLogger.m
//  KIF
//
//  Created by Fahim Farook on 10/3/13.
//
//

#import "KIFJUnitLogger.h"
#import "KIFTestScenario.h"
#import "KIFTestController.h"

@interface KIFJUnitLogger ()

@property (nonatomic, strong) NSMutableDictionary *times;
@property (nonatomic, strong) NSMutableDictionary *errors;
@property (nonatomic, assign) KIFTestScenario *currentScenario;

@end

@implementation KIFJUnitLogger

-(NSFileHandle *)logFileHandle {
	if (!self.fileExt) {
		self.fileExt = @"xml";
	}
	return [super logFileHandle];
}

-(void)logTestingDidStart {
	NSFileHandle *fh = [self logFileHandle];
	if (fh) {
		NSLog(@"Logging KIF test activity to %@", self.filePath);
	}
	self.times = [[NSMutableDictionary alloc] init];
	self.errors = [[NSMutableDictionary alloc] init];
}

-(void)logTestingDidFinish {
	NSTimeInterval total = [[NSDate date] timeIntervalSinceDate:self.controller.testSuiteStartDate];
	// Header
	NSMutableString *buf = [[NSMutableString alloc] initWithString:@"<?xml version='1.0' encoding='utf-8'?>\n<testsuites>\n"];
	// Suite
	[buf appendFormat:@"<testsuite name='%@' tests='%d' errors='%d' failures='0' time='%f'>\n", @"KIF Tests", [self.controller.scenarios count], [_errors count], total];
	// Scenarios
	for (KIFTestScenario *s in self.controller.scenarios) {
		// Error message
		NSError *err = _errors[s.description];
		NSString *errStr = [err localizedDescription];
		err = err.userInfo[NSUnderlyingErrorKey];
		if (err) {
			errStr = [NSString stringWithFormat:@"%@ %@", errStr, [err localizedDescription]];
		}
		// Time
		double time = [_times[s.description] doubleValue];
		[buf appendFormat:@"<testcase name='%@' classname='%@' time='%f'", [s description], NSStringFromClass([s class]), time];
		if (err) {
			[buf appendFormat:@">\n<failure message='%@' type='KIF'>\n%@</failure>\n</testcase>\n", errStr, [s.steps componentsJoinedByString:@"\n"]];
		} else {
			[buf appendString:@" />\n"];
		}
	}
	// Footer
	[buf appendString:@"</testsuite></testsuites>"];
	NSData *data = [buf dataUsingEncoding:NSUTF8StringEncoding];
	NSFileHandle *fh = [self logFileHandle];
	[fh writeData:data];
	[buf release];
}

-(void)logDidStartScenario:(KIFTestScenario *)scenario {
	self.currentScenario = scenario;
}

-(void)logDidSkipScenario:(KIFTestScenario *)scenario {
}

-(void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString {
}

-(void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration {
	_times[_currentScenario.description] = @(duration);
}

-(void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error {
	_errors[_currentScenario.description] = error;
}

-(void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration {
}

@end
