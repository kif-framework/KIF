//
//  PullToRefreshTests.m
//  KIF
//
//  Created by Michael Lupo on 9/22/15.
//
//

#import <KIF/KIFTestCase.h>
#import <KIF/KIFUITestActor-IdentifierTests.h>
#import <KIF/KIFUIViewTestActor.h>
#import <KIF/KIFTestStepValidation.h>

@interface PullToRefreshTests : KIFTestCase
@end

@implementation PullToRefreshTests

- (void)beforeAll
{
    // Ensure that we've scrolled the TestSuite VC back to the top
    [tester waitForViewWithAccessibilityLabel:@"Tapping"];
}

- (void)testPullToRefreshByAccessibilityLabelWithDuration
{
    [tester waitForViewWithAccessibilityIdentifier:@"Test Suite TableView"];
    [tester pullToRefreshViewWithAccessibilityLabel:@"Table View" pullDownDuration:KIFPullToRefreshInAboutAHalfSecond];

    // Implicit scrolling of the table view when searching the view hierarchy is causing "Bingo!" to disappear.
    // Hacky to use viewTester here, but the alternative would be to expose
    // `usingCurrentFrame` functionality on the legacy `tester` API.
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForView];
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForAbsenceOfView];
}

- (void)testPullToRefreshWithBigContentSize
{
    UITableView *tableView;
    [tester waitForAccessibilityElement:NULL view:&tableView withIdentifier:@"Test Suite TableView" tappable:NO];
    CGSize originalSize = tableView.contentSize;
    tableView.contentSize = CGSizeMake(1000, 10000);
    
    [tester pullToRefreshViewWithAccessibilityLabel:@"Table View" pullDownDuration:KIFPullToRefreshInAboutAHalfSecond];

    // Implicit scrolling of the table view when searching the view hierarchy is causing "Bingo!" to disappear.
    // Hacky to use viewTester here, but the alternative would be to expose
    // `usingCurrentFrame` functionality on the legacy `tester` API.
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForView];
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForAbsenceOfView];

    tableView.contentSize = originalSize;
}

@end
