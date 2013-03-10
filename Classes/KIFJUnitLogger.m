//
//  KIFJUnitLogger.m
//  KIF
//
//  Created by Fahim Farook on 10/3/13.
//
//

#import "KIFJUnitLogger.h"

@implementation KIFJUnitLogger

-(NSFileHandle *)logFileHandle {
	if (!self.fileExt) {
		self.fileExt = @"xml";
	}
	return [super logFileHandle];
}

-(void)logTestingDidStart {
}

-(void)logTestingDidFinish {
}

-(void)logDidStartScenario:(KIFTestScenario *)scenario {
}

-(void)logDidSkipScenario:(KIFTestScenario *)scenario {
}

-(void)logDidSkipAddingScenarioGenerator:(NSString *)selectorString {
}

-(void)logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration {
}

-(void)logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error {
}

-(void)logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration {
}

@end
