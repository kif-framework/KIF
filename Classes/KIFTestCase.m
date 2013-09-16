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

- (id)initWithInvocation:(NSInvocation *)anInvocation;
{
    self = [super initWithInvocation:anInvocation];
    if (!self) {
        return nil;
    }

    [self raiseAfterFailure];
    return self;
}

- (void)beforeEach { }
- (void)afterEach  { }
- (void)beforeAll  { }
- (void)afterAll   { }

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

- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop
{
    if (stop) {
        [self writeScreenshotForException:exception];
    }
    
    if (stop && self.stopTestsOnFirstBigFailure) {
        NSLog(@"Fatal failure encountered: %@", exception.description);
        NSLog(@"Stopping tests since stopTestsOnFirstBigFailure = YES");
        
        KIFTestActor *waiter = [[[KIFTestActor alloc] init] autorelease];
        [waiter waitForTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]];
        
        return;
    } else {
        [super failWithException:exception stopTest:stop];
    }
}

- (void)writeScreenshotForException:(NSException *)exception;
{
    NSString *outputPath = [[[NSProcessInfo processInfo] environment] objectForKey:@"KIF_SCREENSHOTS"];
    if (!outputPath) {
        return;
    }
    
    NSArray *windows = [[UIApplication sharedApplication] windowsWithKeyWindow];
    if (windows.count == 0) {
        return;
    }
    
    UIGraphicsBeginImageContext([[windows objectAtIndex:0] bounds].size);
    for (UIWindow *window in windows) {
        [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *filename = [NSString stringWithFormat:@"%@, line %lld", [exception.filename lastPathComponent], exception.lineNumber.longLongValue];
    
    outputPath = [outputPath stringByExpandingTildeInPath];
    outputPath = [outputPath stringByAppendingPathComponent:filename];
    outputPath = [outputPath stringByAppendingPathExtension:@"png"];
    [UIImagePNGRepresentation(image) writeToFile:outputPath atomically:YES];
}

@end
