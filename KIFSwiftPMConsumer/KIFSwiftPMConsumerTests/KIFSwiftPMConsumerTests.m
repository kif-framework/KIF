//
//  KIFSwiftPMConsumerTests.m
//  KIFSwiftPMConsumerTests
//
//  Created by Derek Ostrander on 3/1/21.
//

@import KIF;
#import <XCTest/XCTest.h>


@interface KIFSwiftPMConsumerTests : XCTestCase

@end

@implementation KIFSwiftPMConsumerTests

- (void)testConsumer {
    [[viewTester usingLabel:@"Test Label"] waitForView];
}


@end
