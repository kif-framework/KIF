//
//  NewWebViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIFTestCase.h>
#import <KIF/KIFUITestActor-IdentifierTests.h>
#import <KIF/KIFTestStepValidation.h>

@interface WebViewTests_ViewTestActor : KIFTestCase
@end


@implementation WebViewTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"WebViews"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTappingLinks
{
    [[viewTester usingAccessibilityLabel:@"A link"] tap];
    [[viewTester usingAccessibilityLabel:@"Page 2"] waitForView];
}

- (void)testScrolling
{
    // Off screen, the web view will need to be scrolled down
    [[viewTester usingAccessibilityLabel:@"Footer"] waitForView];
}

- (void)testEnteringText
{
    [[viewTester usingAccessibilityLabel:@"Input Label"] tap];
    [viewTester enterTextIntoCurrentFirstResponder:@"Keyboard text"];
}

@end
