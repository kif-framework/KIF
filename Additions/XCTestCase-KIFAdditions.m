//
//  XCTestCase-KIFAdditions.m
//  KIF
//
//  Created by Tony DiPasquale on 12/9/13.
//
//

#import "XCTestCase-KIFAdditions.h"
#import "LoadableCategory.h"
#import <objc/runtime.h>

MAKE_CATEGORIES_LOADABLE(TestCase_KIFAdditions)

static inline void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@interface XCTestCase ()
- (void)_recordUnexpectedFailureWithDescription:(id)arg1 exception:(id)arg2;
@end

@implementation XCTestCase (KIFAdditions)

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    self.continueAfterFailure = YES;

    [self recordFailureWithDescription:exception.description inFile:exception.userInfo[@"SenTestFilenameKey"] atLine:[exception.userInfo[@"SenTestLineNumberKey"] unsignedIntegerValue] expected:NO];

    if (stop) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Swizzle([XCTestCase class], @selector(_recordUnexpectedFailureWithDescription:exception:), @selector(KIF_recordUnexpectedFailureWithDescription:exception:));
        });
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

- (void)KIF_recordUnexpectedFailureWithDescription:(id)arg1 exception:(NSException *)arg2
{
    if (![[arg2 name] isEqualToString:@"KIFFailureException"]) {
        [self KIF_recordUnexpectedFailureWithDescription:arg1 exception:arg2];
    }
}

@end
