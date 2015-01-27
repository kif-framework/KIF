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

@interface NewWebViewTests : KIFTestCase
@end

@implementation NewWebViewTests

- (void)beforeEach
{
    [[viewTester usingLabel:@"WebViews"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTappingLinks
{
    [[viewTester usingLabel:@"A link"] tap];
    [[viewTester usingLabel:@"Page 2"] waitForView];
}

- (void)testScrolling
{
    // Off screen, the web view will need to be scrolled down
    [[viewTester usingLabel:@"Footer"] waitForView];
}

- (void)testEnteringText
{
    [[viewTester usingLabel:@"Input Label"] tap];
    [viewTester enterTextIntoCurrentFirstResponder:@"Keyboard text"];
}

@end
