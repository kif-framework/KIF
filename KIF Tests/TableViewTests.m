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
    [tester tapRowInTableViewWithAccessibilityLabel:@"TableView Tests Table" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [tester waitForViewWithAccessibilityLabel:@"Last Cell" traits:UIAccessibilityTraitSelected];
    [tester tapRowInTableViewWithAccessibilityLabel:@"TableView Tests Table" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [tester waitForViewWithAccessibilityLabel:@"First Cell" traits:UIAccessibilityTraitSelected];
}

- (void)testTappingLastRowAndSection
{
    [tester tapRowInTableViewWithAccessibilityLabel:@"TableView Tests Table" atIndexPath:[NSIndexPath indexPathForRow:-1 inSection:-1]];
    [tester waitForViewWithAccessibilityLabel:@"Last Cell" traits:UIAccessibilityTraitSelected];
}

- (void)testOutOfBounds
{
    KIFExpectFailure([tester tapRowInTableViewWithAccessibilityLabel:@"TableView Tests Table" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:99]]);
}

- (void)testUnknownTable
{
    KIFExpectFailure([[tester usingTimeout:1] tapRowInTableViewWithAccessibilityLabel:@"Unknown Table" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]);
}

@end
