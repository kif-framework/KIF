//
//  KIFTester.m
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//
//

#import "KIFTester.h"

@implementation KIFTester

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line
{
    self = [super init];
    if (self) {
        _file = [file retain];
        _line = line;
    }
    return self;
}

- (KIFTestStepResult)run:(KIFTestStep *)step
{
    NSDate *startDate = [NSDate date];
    
    KIFTestStepResult result;
    NSError *error;
    
    while ((result = [step executeAndReturnError:&error]) == KIFTestStepResultWait && -[startDate timeIntervalSinceNow] < step.timeout) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    if (result == KIFTestStepResultSuccess) {
        return result;
    }
    
    if (result == KIFTestStepResultWait) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:error, NSUnderlyingErrorKey, [NSString stringWithFormat:@"The step timed out after %.2f seconds: %@", step.timeout, error.localizedDescription], NSLocalizedDescriptionKey, nil];
        error = [NSError errorWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:userInfo];
    }
    
    [self.delegate tester:self didFailTestStep:KIFTestStepResultFailure error:error];
    return KIFTestStepResultFailure;
}

- (KIFTestStepResult)runBlock:(KIFTestStepExecutionBlock)block
{
    return [self run:[KIFTestStep stepWithDescription:@"KIFTester generated block" executionBlock:block]];
}

- (void)dealloc
{
    [_file release];
    [super dealloc];
}

@end
