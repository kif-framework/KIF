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
    BOOL failed;\
    {\
        _MockKIFTestActorDelegate *self = [_MockKIFTestActorDelegate mockDelegate];\
        @try { stmt; }\
        @catch (NSException *exception) { }\
        failed = self.failed;\
    }\
    if (!failed) {\
        STFail(@"%s should have failed.", #stmt);\
    }\
}

@interface _MockKIFTestActorDelegate : NSObject<KIFTestActorDelegate>
@property (nonatomic, assign) BOOL failed;
@property (nonatomic, retain) NSString *errorDescription;
@property (nonatomic, assign) BOOL stopped;

+ (instancetype)mockDelegate;

@end
