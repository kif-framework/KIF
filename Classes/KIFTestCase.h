//
//  KIFTestCase.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "KIFTestContext.h"
#import "KIFTester+Generic.h"
#import "KIFTester+UI.h"

#define tester [KIFTestCaseSharedContext testerInFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__]

extern KIFTestContext *KIFTestCaseSharedContext;

@interface KIFTestCase : SenTestCase
@end

@interface KIFTestCase (Setup_and_Teardown)

- (void)beforeAll;
- (void)beforeEach;
- (void)afterEach;
- (void)afterAll;

@end
