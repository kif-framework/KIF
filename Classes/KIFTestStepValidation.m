//
//  KIFTestStepValidation.m
//  KIF
//
//  Created by Brian Nickel on 7/27/13.
//
//

#import "KIFTestStepValidation.h"

@implementation _MockKIFTestActorDelegate

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    self.failed = YES;
    self.errorDescription = exception.userInfo[SenTestDescriptionKey];
    self.stopped = stop;
    if (stop) {
        [exception raise];
    }
}

+ (instancetype)mockDelegate
{
    return [[[self alloc] init] autorelease];
}

@end
