//
//  SwiftUITappingTests.m
//  KIF
//
//  Created by Bartłomiej Włodarczak on 03/02/2025.
//

#import <KIF/KIF.h>

@interface SwiftUITappingTests : KIFTestCase
@end

@implementation SwiftUITappingTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"SwiftUI Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testTappingTextWithTapGesture
{
    [tester tapViewWithAccessibilityLabel:@"Text with tap gesture"];
    [tester waitForViewWithAccessibilityLabel:@"Tap count: 1"];
}

- (void)testTappingPartiallyOffscreenTextWithTapGesture
{
    [tester tapViewWithAccessibilityLabel:@"Partially offscreen text with tap gesture"];
    [tester waitForViewWithAccessibilityLabel:@"Tap count: 1"];
}

- (void)testTappingButton
{
    [tester tapViewWithAccessibilityLabel:@"Button"];
    [tester waitForViewWithAccessibilityLabel:@"Tap count: 1"];
    
}

- (void)testTappingToggleSwitch
{
    [tester waitForViewWithAccessibilityLabel:@"Enabled"];
    [tester longPressViewWithAccessibilityLabel:@"Toggle switch" duration: 1.0f];
    [tester waitForViewWithAccessibilityLabel:@"Disabled"];
    
    if (@available(iOS 17.0, *)) {
        [tester longPressViewWithAccessibilityLabel:@"Toggle switch" value: nil traits:UIAccessibilityTraitToggleButton | UIAccessibilityTraitButton duration:1.0f];
        [tester waitForViewWithAccessibilityLabel:@"Enabled"];
    }
}

- (void)testTappingStepper
{
    [tester tapViewWithAccessibilityLabel:@"Increment"];
    [tester waitForViewWithAccessibilityLabel:@"Value: 51"];
    [tester tapViewWithAccessibilityLabel:@"Decrement"];
    [tester waitForViewWithAccessibilityLabel:@"Value: 50"];
}

- (void)testLongPressingImage
{
    [tester tapViewWithAccessibilityLabel:@"Love"];
    [tester waitForViewWithAccessibilityLabel:@"Long press to toggle"];
    [tester longPressViewWithAccessibilityLabel:@"Love" duration:1];
    [tester waitForViewWithAccessibilityLabel:@"Tap to toggle"];
}

- (void)testTappingUIViewRepresentableLabel
{
    [tester tapViewWithAccessibilityLabel:@"UIViewRepresentable label"];
    [tester waitForViewWithAccessibilityLabel:@"Tap count: 1"];
}

@end
