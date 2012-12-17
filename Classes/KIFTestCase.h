//
//  KIFTestCase.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "KIFTester+Generic.h"
#import "KIFTester+UI.h"

#define tester [self testerInFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__]

@interface KIFTestCase : SenTestCase<KIFTesterDelegate>

- (KIFTester *)testerInFile:(NSString *)file atLine:(NSInteger)line;

@end

@interface KIFTestCase (Setup_and_Teardown)

- (void)beforeAll;
- (void)beforeEach;
- (void)afterEach;
- (void)afterAll;

@end
