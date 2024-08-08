//
//  AccessibilityIdentifierPullToRefreshTests.m
//  KIF
//
//  Created by Michael Lupo on 9/22/15.
//
//

#import <KIF/KIFTestCase.h>
#import <KIF/KIFUITestActor-IdentifierTests.h>
#import <KIF/KIFUIViewTestActor.h>

#import <KIF/KIFTestStepValidation.h>

@interface AccessibilityIdentifierPullToRefreshTests : KIFTestCase
@end

@implementation AccessibilityIdentifierPullToRefreshTests

- (void)beforeAll
{
    // Ensure that we've scrolled the TestSuite VC back to the top
    [tester waitForViewWithAccessibilityLabel:@"Tapping"];
}

- (void)testPullToRefreshByAccessibilityIdentifier
{
    [tester waitForViewWithAccessibilityIdentifier:@"Test Suite TableView"];
    [tester pullToRefreshViewWithAccessibilityIdentifier:@"Test Suite TableView"];

    // Implicit scrolling of the table view when searching the view hierarchy is causing "Bingo!" to disappear.
    // Hacky to use viewTester here, but the alternative would be to expose
    // `usingCurrentFrame` functionality on the legacy `tester` API.
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForView];
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForAbsenceOfView];
}

- (void)testPullToRefreshByAccessibilityIdentifierWithDuration
{
    [tester waitForViewWithAccessibilityIdentifier:@"Test Suite TableView"];
    [tester pullToRefreshViewWithAccessibilityIdentifier:@"Test Suite TableView" pullDownDuration:KIFPullToRefreshInAboutAHalfSecond];

    // Implicit scrolling of the table view when searching the view hierarchy is causing "Bingo!" to disappear.
    // Hacky to use viewTester here, but the alternative would be to expose
    // `usingCurrentFrame` functionality on the legacy `tester` API.
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForView];
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForAbsenceOfView];
}

@end
