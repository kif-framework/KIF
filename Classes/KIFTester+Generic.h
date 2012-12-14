//
//  KIFTester+Generic.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTester.h"

@interface KIFTester (Generic)

- (void)fail;
- (void)waitForTimeInterval:(NSTimeInterval)timeInterval;
- (void)giveUpOnAllTestsAndRunAppForever;

@end
