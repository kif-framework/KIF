//
//  PullToRefreshTests_ViewTestActor.m
//  KIF
//
//  Created by Alex Odawa on 1/29/16.
//
//

#import <Foundation/Foundation.h>
#import "KIFTestCase.h"
#import "KIFUIViewTestActor.h"

@interface PullToRefreshTests_ViewTestActor : KIFTestCase
@end

@implementation PullToRefreshTests_ViewTestActor

- (void)beforeAll
{
    // Ensure that we've scrolled the TestSuite VC back to the top
    [tester waitForViewWithAccessibilityLabel:@"Tapping"];
}

- (void)testPullToRefreshByAccessibilityLabelWithDuration
{
    [[viewTester usingIdentifier:@"Test Suite TableView"] waitForView];
    [[viewTester usingLabel:@"Table View"] pullToRefreshWithDuration:KIFPullToRefreshInAboutAHalfSecond];

    // Implicit scrolling of the table view when searching the view hierarchy is causing "Bingo!" to disappear.
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForView];
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForAbsenceOfView];
}

- (void)testPullToRefreshWithBigContentSize
{
    
    UITableView *tableView = (id)[[viewTester usingIdentifier:@"Test Suite TableView"] waitForView];
    CGSize originalSize = tableView.contentSize;
    tableView.contentSize = CGSizeMake(1000, 10000);

    [[viewTester usingLabel:@"Table View"] pullToRefreshWithDuration:KIFPullToRefreshInAboutAHalfSecond];

    // Implicit scrolling of the table view when searching the view hierarchy is causing "Bingo!" to disappear.
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForView];
    [[[viewTester usingCurrentFrame] usingLabel:@"Bingo!"] waitForAbsenceOfView];

    tableView.contentSize = originalSize;
}

@end
