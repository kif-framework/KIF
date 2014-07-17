//
//  XCTestCase-KIFAdditions.m
//  KIF
//
//  Created by Tony DiPasquale on 12/9/13.
//
//

#import "XCTestCase-KIFAdditions.h"
#import "LoadableCategory.h"
#import "UIApplication-KIFAdditions.h"

MAKE_CATEGORIES_LOADABLE(TestCase_KIFAdditions)

@implementation XCTestCase (KIFAdditions)

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    self.continueAfterFailure = YES;
    [self writeScreenshotForException:exception];
    
    [self recordFailureWithDescription:exception.description inFile:exception.userInfo[@"SenTestFilenameKey"] atLine:[exception.userInfo[@"SenTestLineNumberKey"] unsignedIntegerValue] expected:NO];

    if (stop) {
        [exception raise];
    }
}

- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop
{
    NSException *lastException = exceptions.lastObject;
    for (NSException *exception in exceptions) {
        [self failWithException:exception stopTest:(exception == lastException ? stop : NO)];
    }
}

- (void)writeScreenshotForException:(NSException *)exception {
    [[UIApplication sharedApplication] writeScreenshotForLine:[exception.userInfo[@"SenTestLineNumberKey"] unsignedIntegerValue] inFile:exception.userInfo[@"SenTestFilenameKey"] description:nil error:NULL];
}

@end
