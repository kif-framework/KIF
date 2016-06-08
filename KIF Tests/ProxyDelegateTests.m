//
//  ProxyDelegateTests.m
//  KIF
//
//  Created by Jacek Suliga on 5/23/16.
//
//

#import "KIFProxyDelegate.h"

// Helper class for the original delegate
@interface ProxyTestHelperOrg: NSObject

@property (copy) dispatch_block_t functionAblock;
@property (copy) dispatch_block_t functionBblock;
@property (copy) dispatch_block_t functionCblock;

@end

@implementation ProxyTestHelperOrg

-(void)sampleFunctionA
{
    if (self.functionAblock) {
        self.functionAblock();
    }
}

-(void)sampleFunctionB:(id)someObject
{
    if (self.functionBblock) {
        self.functionBblock();
    }
}

-(void)sampleFunctionC
{
    if (self.functionCblock) {
        self.functionCblock();
    }
}

@end

// Helper class for the replacement delegate
@interface ProxyTestHelperRepl: NSObject

@property (copy) dispatch_block_t functionAblock;
@property (copy) dispatch_block_t functionBblock;
@property (copy) dispatch_block_t functionDblock;

@end

@implementation ProxyTestHelperRepl

-(void)sampleFunctionA
{
    if (self.functionAblock) {
        self.functionAblock();
    }
}

-(void)sampleFunctionB:(id)someObject
{
    if (self.functionBblock) {
        self.functionBblock();
    }
}

-(void)sampleFunctionD
{
    if (self.functionDblock) {
        self.functionDblock();
    }
}

@end


@interface ProxyDelegateTests: XCTestCase
@end

@implementation ProxyDelegateTests

-(void)testDelegate {
    // Configure original "delegate"
    ProxyTestHelperOrg * original = [ProxyTestHelperOrg new];

    __block BOOL originalAcalled = NO;
    __block BOOL originalBcalled = NO;
    __block BOOL originalCcalled = NO;

    original.functionAblock = ^{
        originalAcalled = YES;
    };
    original.functionBblock = ^{
        originalBcalled = YES;
    };
    original.functionCblock = ^{
        originalCcalled = YES;
    };

    // Configure replacement "delegate"
    ProxyTestHelperRepl * replacement = [ProxyTestHelperRepl new];

    __block BOOL replacementAcalled = NO;
    __block BOOL replacementBcalled = NO;
    __block BOOL replacementDcalled = NO;

    replacement.functionAblock = ^{
        replacementAcalled = YES;
    };
    replacement.functionBblock = ^{
        replacementBcalled = YES;
    };
    replacement.functionDblock = ^{
        replacementDcalled = YES;
    };

    KIFProxyDelegate * proxyDelegate = [[KIFProxyDelegate alloc] initWithOriginalDelegate:original replacementDelegate:replacement];

    // Calling function A on proxyDelegate should call function A on the replacement and original as well
    [proxyDelegate performSelector:@selector(sampleFunctionA)];
    XCTAssert(replacementAcalled && originalAcalled, @"Replacement not called, or original not called!");

    // Calling function B on proxyDelegate should call function B on the replacement, and original as well
    [proxyDelegate performSelector:@selector(sampleFunctionB:) withObject:self];
    XCTAssert(replacementBcalled && originalBcalled, @"Replacement not called, or original not called!");

    // Calling function C on proxyDelegate should call function C on the original, as replacement does not implement it
    [proxyDelegate performSelector:@selector(sampleFunctionC)];
    XCTAssert(originalCcalled, @"Original not called");

    // Calling function D on proxyDelegate should call function D on the replacement, as only it implements it
    [proxyDelegate performSelector:@selector(sampleFunctionD)];
    XCTAssert(replacementDcalled, @"Replacement not called");

    // Final state for the original delegate
    XCTAssert(originalAcalled && originalBcalled && originalCcalled, @"Original not called");

    // Final state for the replacement delegate
    XCTAssert(replacementAcalled && replacementBcalled && replacementDcalled, @"Replacement not called");
}

@end