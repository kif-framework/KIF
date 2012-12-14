//
//  KIFTester+Generic.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTester.h"

@interface KIFTester (Generic)

- (void)succeed;
- (void)fail;

- (void)waitForTimeInterval:(NSTimeInterval)timeInterval;
- (void)waitForNotificationName:(NSString*)name object:(id)object;
- (void)waitForNotificationName:(NSString *)name object:(id)object whileExecutingStep:(KIFTestStep *)childStep;

- (void)simulateMemoryWarning;

- (void)giveUpOnAllTestsAndRunAppForever;

@end
