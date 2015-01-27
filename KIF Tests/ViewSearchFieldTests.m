//
//  ViewSearchFieldTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//


#import <KIF/KIF.h>
#import <KIF/UIApplication-KIFAdditions.h>

@interface ViewSearchFieldTests : KIFTestCase
@end

@implementation ViewSearchFieldTests

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"TableViews"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testWaitingForSearchFieldToBecomeFirstResponder
{
    [[viewTester usingTraits:UIAccessibilityTraitSearchField] tap];
    [[viewTester usingTraits:UIAccessibilityTraitSearchField] waitToBecomeFirstResponder];
    [viewTester enterTextIntoCurrentFirstResponder:@"text"];
    [[[viewTester usingValue:@"text"] usingTraits:UIAccessibilityTraitSearchField] waitForView];
}

@end
