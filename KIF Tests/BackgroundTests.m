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
    if ([UIDevice.currentDevice.systemVersion compare:@"8.0" options:NSNumericSearch] < 0) {
        return nil;
    }
    
    return [super defaultTestSuite];
}

- (void)beforeEach {
    [tester tapViewWithAccessibilityLabel:@"Background"];
}

- (void)afterEach {
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    [tester waitForViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitHeader];
}

- (void)testBackgroundApp {
    if (@available(iOS 14.0, *)) { // Xcode 12, UIAutomation framework not available
        return;
    }
    [tester waitForViewWithAccessibilityLabel:@"Start"];
    [system deactivateAppForDuration:5];
    [tester waitForViewWithAccessibilityLabel:@"Back"];
}

@end
