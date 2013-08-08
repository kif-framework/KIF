//
//  KIFTestStepValidation.h
//  KIF
//
//  Created by Brian Nickel on 7/27/13.
//
//

#import <Foundation/Foundation.h>
#import "KIFTestCase.h"

#define KIFExpectFailure(stmt) \
{\
    _MockKIFTestActorDelegate *mockDelegate = [_MockKIFTestActorDelegate mockDelegate];\
    {\
        _MockKIFTestActorDelegate *self = mockDelegate;\
        @try { stmt; }\
        @catch (NSException *exception) { }\
    }\
    if (!mockDelegate.failed) {\
        STFail(@"%s should have failed.", #stmt);\
    }\
}

#define KIFExpectFailureWithCount(stmt, cnt) \
{\
    _MockKIFTestActorDelegate *mockDelegate = [_MockKIFTestActorDelegate mockDelegate];\
    {\
            _MockKIFTestActorDelegate *self = mockDelegate;\
            @try { stmt; }\
            @catch (NSException *exception) { }\
    }\
    if (!mockDelegate.failed) {\
        STFail(@"%s should have failed.", #stmt);\
    }\
    STAssertEquals((NSUInteger)cnt, mockDelegate.exceptions.count, @"Expected a different number of exceptions.");\
}


@interface _MockKIFTestActorDelegate : NSObject<KIFTestActorDelegate>
@property (nonatomic, assign) BOOL failed;
@property (nonatomic, retain) NSArray *exceptions;
@property (nonatomic, assign) BOOL stopped;

+ (instancetype)mockDelegate;

@end
