//
//  BackgroundTests.m
//  KIF
//
//  Created by Jordan Zucker on 5/18/15.
//
//

#import <KIF/KIF.h>

@interface BackgroundTests : KIFTestCase

@end

@implementation BackgroundTests

+ (XCTestSuite *)defaultTestSuite
{
    // 'deactivateAppForDuration' can't be used on iOS7
    // The console shows a message "AX Lookup problem! 22 com.apple.iphone.axserver:-1"
    // On iOS8 under Mac OS 10.10 we are seeing infinate hangs where the app never returns, skip these too.
    if ([UIDevice.currentDevice.systemVersion compare:@"9.0" options:NSNumericSearch] < 0) {
        return nil;
    }
    
    return [super defaultTestSuite];
}

- (void)beforeEach {
    [tester tapViewWithAccessibilityLabel:@"Background"];
}

- (void)afterEach {
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testBackgroundApp {
    [tester waitForViewWithAccessibilityLabel:@"Start"];
    [tester deactivateAppForDuration:5];
    [tester waitForViewWithAccessibilityLabel:@"Back"];
}

@end
