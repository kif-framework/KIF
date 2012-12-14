
//
//  KIFTestCase.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTestCase.h"

#define SIG(class, selector) [class instanceMethodSignatureForSelector:selector]

KIFTestContext *KIFTestCaseSharedContext = nil;

@implementation KIFTestCase

- (void)beforeEach { }
- (void)afterEach  { }

- (void)setUp
{
    [super setUp];
    if (KIFTestCaseSharedContext == nil) {
        KIFTestCaseSharedContext = [[KIFTestContext alloc] init];
    }
    
    if ([self isNotBeforeOrAfter]) {
        [KIFTestCaseSharedContext resetWithTest:self];
        [self beforeEach];
    }
    
    [KIFTestCaseSharedContext resetWithTest:self];
}

- (void)tearDown
{
    if ([self isNotBeforeOrAfter]) {
        [KIFTestCaseSharedContext resetWithTest:self];
        [self afterEach];
    }
    
    [KIFTestCaseSharedContext resetWithTest:nil];
    [super tearDown];
}

+ (NSArray *)testInvocations
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

- (BOOL)isNotBeforeOrAfter
{
    SEL selector = self.invocation.selector;
    return selector != @selector(beforeAll) && selector != @selector(afterAll);
}

@end
