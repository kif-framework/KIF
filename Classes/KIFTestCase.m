//
//  KIFTestCase.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestCase.h"
#import <UIKit/UIKit.h>
#import "UIApplication-KIFAdditions.h"
#import "KIFTestActor.h"

#define SIG(class, selector) [class instanceMethodSignatureForSelector:selector]


@implementation KIFTestCase

NSComparisonResult selectorSort(NSInvocation *invocOne, NSInvocation *invocTwo, void *reverse);

+ (id)defaultTestSuite
{
    if (self == [KIFTestCase class]) {
        // Don't run KIFTestCase "tests"
        return nil;
    }
    
    return [super defaultTestSuite];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation;
{
    self = [super initWithInvocation:anInvocation];
    if (!self) {
        return nil;
    }

#ifndef KIF_SENTEST
    self.continueAfterFailure = NO;
#else
    [self raiseAfterFailure];
#endif
    return self;
}

- (void)beforeEach { }
- (void)afterEach  { }
- (void)beforeAll  { }
- (void)afterAll   { }

#ifndef KIF_SENTEST

NSComparisonResult selectorSort(NSInvocation *invocOne, NSInvocation *invocTwo, void *reverse) {
    
    NSString *selectorOne =  NSStringFromSelector([invocOne selector]);
    NSString *selectorTwo =  NSStringFromSelector([invocTwo selector]);
    return [selectorOne compare:selectorTwo options:NSCaseInsensitiveSearch];
}

+ (NSArray *)testInvocations
{
    NSArray *disorderedInvoc = [super testInvocations];
    NSArray *newArray = [disorderedInvoc sortedArrayUsingFunction:selectorSort context:NULL];
    return newArray;
}

- (void)setUp;
{
    [self beforeEach];
}

- (void)tearDown;
{
    [self afterEach];
}

+ (void)setUp
{
    [[self new] beforeAll];
}

+ (void)tearDown
{
    [[self new] afterAll];
}

#else

- (void)setUp;
{
    [super setUp];

    if ([self isNotBeforeOrAfter]) {
        [self beforeEach];
    }
}

- (void)tearDown;
{
    if ([self isNotBeforeOrAfter]) {
        [self afterEach];
    }

    [super tearDown];
}

+ (NSArray *)testInvocations;
{
    if (self == [KIFTestCase class]) {
        return nil;
    }
    
    NSMutableArray *testInvocations = [NSMutableArray arrayWithArray:[super testInvocations]];
    
    if ([self instancesRespondToSelector:@selector(beforeAll)]) {
        NSInvocation *beforeAll = [NSInvocation invocationWithMethodSignature:SIG(self, @selector(beforeAll))];
        beforeAll.selector = @selector(beforeAll);
        [testInvocations insertObject:beforeAll atIndex:0];
    }
    
    if ([self instancesRespondToSelector:@selector(afterAll)]) {
        NSInvocation *afterAll = [NSInvocation invocationWithMethodSignature:SIG(self, @selector(afterAll))];
        afterAll.selector = @selector(afterAll);
        [testInvocations addObject:afterAll];
    }
    
    return testInvocations;
}

- (BOOL)isNotBeforeOrAfter;
{
    SEL selector = self.invocation.selector;
    return selector != @selector(beforeAll) && selector != @selector(afterAll);
}

#endif

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    if (stop) {
        [self writeScreenshotForException:exception];
    }
    
    if (stop && self.stopTestsOnFirstBigFailure) {
        NSLog(@"Fatal failure encountered: %@", exception.description);
        NSLog(@"Stopping tests since stopTestsOnFirstBigFailure = YES");
        
        KIFTestActor *waiter = [[KIFTestActor alloc] init];
        [waiter waitForTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]];
        
        return;
    } else {
        [super failWithException:exception stopTest:stop];
    }
}

- (void)writeScreenshotForException:(NSException *)exception;
{
#ifndef KIF_SENTEST
    [[UIApplication sharedApplication] writeScreenshotForLine:[exception.userInfo[@"SenTestLineNumberKey"] unsignedIntegerValue] inFile:exception.userInfo[@"SenTestFilenameKey"] description:nil error:NULL];
#else
    [[UIApplication sharedApplication] writeScreenshotForLine:exception.lineNumber.unsignedIntegerValue inFile:exception.filename description:nil error:NULL];
#endif
}

@end
