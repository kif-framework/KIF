
//
//  KIFTestCase.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTestCase.h"
#import "KIFTester.h"

#define SIG(class, selector) [class instanceMethodSignatureForSelector:selector]

@implementation KIFTestCase

- (id) initWithInvocation:(NSInvocation *) anInvocation
{
    self = [super initWithInvocation:anInvocation];
    [self raiseAfterFailure];
    return self;
}

- (void)beforeEach { }
- (void)afterEach  { }

- (void)setUp
{
    [super setUp];
    
    if ([self isNotBeforeOrAfter]) {
        [self beforeEach];
    }
}

- (void)tearDown
{
    if ([self isNotBeforeOrAfter]) {
        [self afterEach];
    }
    
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

- (KIFTester *)testerInFile:(NSString *)file atLine:(NSInteger)line
{
    KIFTester *myTester = [[[KIFTester alloc] initWithFile:file line:line] autorelease];
    myTester.delegate = self;
    return myTester;
}

@end
