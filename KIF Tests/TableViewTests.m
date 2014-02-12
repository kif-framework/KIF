//
//  TableViewTests.m
//  Test Suite
//
//  Created by Brian Nickel on 7/31/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@interface TableViewTests : KIFTestCase
@end

@implementation TableViewTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"TableViews"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testTappingRows
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] inTableViewWithAccessibilityIdentifier:@"TableView Tests Table"];
    [tester waitForViewWithAccessibilityLabel:@"Last Cell" traits:UIAccessibilityTraitSelected];
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"TableView Tests Table"];
    [tester waitForViewWithAccessibilityLabel:@"First Cell" traits:UIAccessibilityTraitSelected];
}

- (void)testTappingLastRowAndSection
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:-1] inTableViewWithAccessibilityIdentifier:@"TableView Tests Table"];
    [tester waitForViewWithAccessibilityLabel:@"Last Cell" traits:UIAccessibilityTraitSelected];
}

- (void)testOutOfBounds
{
    KIFExpectFailure([tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:99] inTableViewWithAccessibilityIdentifier:@"TableView Tests Table"]);
}

- (void)testUnknownTable
{
    KIFExpectFailure([[tester usingTimeout:1] tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Unknown Table"]);
}

- (void)testScrollingToTop
{
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] inTableViewWithAccessibilityIdentifier:@"TableView Tests Table"];
    [tester tapStatusBar];
    
    UITableView *tableView;
    [tester waitForAccessibilityElement:NULL view:&tableView withIdentifier:@"TableView Tests Table" tappable:NO];
    [tester runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(tableView.contentOffset.y == - tableView.contentInset.top, error, @"Waited for scroll view to scroll to top, but it ended at %@", NSStringFromCGPoint(tableView.contentOffset));
        return KIFTestStepResultSuccess;
    }];
}

- (void)testTogglingSwitch
{
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"Table View Switch"];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Table View Switch"];
}

@end
