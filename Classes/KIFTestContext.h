//
//  KIFTextContext.h
//  KIF
//
//  Created by Brian Nickel on 12/13/12.
//
//

#import <Foundation/Foundation.h>
#import "KIFTester.h"

@interface KIFTestContext : NSObject<KIFTesterDelegate>

@property(nonatomic,readonly) id test;
@property(nonatomic,readonly) BOOL hasEncounteredAnError;

- (void)resetWithTest:(id)test;
- (KIFTester *)testerInFile:(NSString *)file atLine:(NSInteger)line;

@end