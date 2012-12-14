//
//  KIFTester+Generic.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTester+Generic.h"

@implementation KIFTester (Generic)

- (void)fail
{
    [self run:[KIFTestStep stepThatFails]];
}

- (void)waitForTimeInterval:(NSTimeInterval)timeInterval
{
    NSString *description = [NSString stringWithFormat:@"Waiting %f seconds", timeInterval];
    
    [self run:[KIFTestStep stepToWaitForTimeInterval:timeInterval description:description]];
}

- (void)giveUpOnAllTestsAndRunAppForever
{
    [self waitForTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]];
}

@end
