//
//  NewTableViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//


#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"
#import "UIApplication-KIFAdditions.h"

@interface TableViewTests_ViewTestActor : KIFTestCase
@end

@implementation TableViewTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"TableViews"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testTappingRows
{
    [[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    [[[viewTester usingAccessibilityLabel:@"Last Cell"] usingTraits:UIAccessibilityTraitSelected] waitForView];
    [[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[[viewTester usingAccessibilityLabel:@"First Cell"] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingLastRowAndSection
{
    [[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:-1]];
    [[[viewTester usingAccessibilityLabel:@"Last Cell"] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testOutOfBounds
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityIdentifier:@"TableView Tests Table"] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:99]]);
}

- (void)testUnknownTable
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityIdentifier:@"Unknown Table"] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]);
}

- (void)testScrollingToTop
{
    [[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [viewTester tapStatusBar];

    UITableView *tableView = (UITableView *)[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"].view;
    [viewTester runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(tableView.contentOffset.y == - tableView.contentInset.top, error, @"Waited for scroll view to scroll to top, but it ended at %@", NSStringFromCGPoint(tableView.contentOffset));
        return KIFTestStepResultSuccess;
    }];
}

- (void)testTappingRowsByLabel
{
    // Tap the first row, which is already visible
    [[viewTester usingAccessibilityLabel:@"First Cell"] tap];

    // Tap the last row, which will need to be scrolled up
    [[viewTester usingAccessibilityLabel:@"Last Cell"] tap];

    // Tap the first row, which will need to be scrolled down
    [[viewTester usingAccessibilityLabel:@"First Cell"] tap];
}

- (void)testMoveRowDown
{
    [[viewTester usingAccessibilityLabel:@"Edit"] tap];

    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 0", @"");
    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 4", @"");

    [[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] moveRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] toIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];

    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 1", @"");
    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 0", @"");

    [[viewTester usingAccessibilityLabel:@"Done"] tap];
}

- (void)testMoveRowUp
{
    [[viewTester usingAccessibilityLabel:@"Edit"] tap];

    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 0", @"");
    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 4", @"");

    [[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] moveRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];

    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 4", @"");
    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 3", @"");

    [[viewTester usingAccessibilityLabel:@"Done"] tap];
}

- (void)testMoveRowUpUsingNegativeRowIndexes
{
    [[viewTester usingAccessibilityLabel:@"Edit"] tap];

    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-3 inSection:1]].textLabel.text, @"Cell 35", @"");
    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:1]].textLabel.text, @"Cell 37", @"");

    [[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] moveRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:1] toIndexPath:[NSIndexPath indexPathForRow:-3 inSection:1]];

    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-3 inSection:1]].textLabel.text, @"Cell 37", @"");
    __KIFAssertEqualObjects([[viewTester usingAccessibilityIdentifier:@"TableView Tests Table"] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:1]].textLabel.text, @"Cell 36", @"");

    [[viewTester usingAccessibilityLabel:@"Done"] tap];
}

- (void)testTogglingSwitch
{
    [[viewTester usingAccessibilityLabel:@"Table View Switch"] setSwitchOn:NO];
    [[viewTester usingAccessibilityLabel:@"Table View Switch"] setSwitchOn:YES];
}

- (void)testButtonAbsentAfterRemoveFromSuperview
{
    [[viewTester usingAccessibilityLabel:@"Button"] waitForView];

    [[viewTester usingAccessibilityLabel:@"Button"].view removeFromSuperview];
    [[viewTester usingAccessibilityLabel:@"Button"] waitForAbsenceOfView];
}

- (void)testButtonAbsentAfterSetHidden
{
    [[viewTester usingAccessibilityLabel:@"Button"] waitForView];

    UIView *button = [viewTester usingAccessibilityLabel:@"Button"].view;

    [button setHidden:YES];
    [[viewTester usingAccessibilityLabel:@"Button"] waitForAbsenceOfView];

    [button setHidden:NO];
    [[viewTester usingAccessibilityLabel:@"Button"] waitForView];
}

- (void)testEnteringTextIntoATextFieldInATableCell
{
    [[viewTester usingAccessibilityLabel:@"TextField"] enterText:@"Test-Driven Development"];
}

@end
