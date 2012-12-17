//
//  KIFTextContext.m
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//
//

#import "KIFTestContext.h"
#import <SenTestingKit/SenTestingKit.h>

@interface NSObject (failWithException)
- (void)failWithException:(NSException *)exception;
@end

@implementation KIFTestContext

- (KIFTester *)testerInFile:(NSString *)file atLine:(NSInteger)line
{
    if (self.hasEncounteredAnError) {
        return nil;
    }
    
    KIFTester *tester = [[[KIFTester alloc] initWithFile:file line:line] autorelease];
    tester.delegate = self;
    return tester;
}

- (void)resetWithTest:(id)test
{
    _hasEncounteredAnError = NO;
    
    if (_test == test) {
        return;
    }
    
    [_test release];
    _test = test;
    [test retain];
}

- (void)tester:(KIFTester *)tester didFailTestStep:(KIFTestStep *)step error:(NSError *)error
{
    _hasEncounteredAnError = YES;
    [self.test failWithException:[NSException failureInFile:tester.file atLine:tester.line withDescription:error.localizedDescription]];
}

- (void)dealloc
{
    [_test release];
    [super dealloc];
}

@end
