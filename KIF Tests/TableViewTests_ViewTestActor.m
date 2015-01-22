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

@implementation KIFUIViewTestActor (tableViewTests)

- (instancetype)table;
{
    return [viewTester usingAccessibilityIdentifier:@"TableView Tests Table"];
}

- (instancetype)doneButton;
{
    return [viewTester usingAccessibilityLabel:@"Done"];
}

- (instancetype)editButton;
{
    return [viewTester usingAccessibilityLabel:@"Edit"];
}

- (instancetype)button;
{
    return [viewTester usingAccessibilityLabel:@"Button"];
}

- (instancetype)firstCell;
{
    return [viewTester usingAccessibilityLabel:@"First Cell"];
}

- (instancetype)lastCell;
{
    return [viewTester usingAccessibilityLabel:@"Last Cell"];
}

- (instancetype)tableViewSwitch;
{
    return [viewTester usingAccessibilityLabel:@"Table View Switch"];
}

@end

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
    [[viewTester table] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    [[[viewTester lastCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
    [[viewTester table] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[[viewTester firstCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testTappingLastRowAndSection
{
    [[viewTester table] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:-1]];
    [[[viewTester lastCell] usingTraits:UIAccessibilityTraitSelected] waitForView];
}

- (void)testOutOfBounds
{
    KIFExpectFailure([[[viewTester table ]usingTimeout:1] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:99]]);
}

- (void)testUnknownTable
{
    KIFExpectFailure([[[viewTester usingTimeout:1] usingAccessibilityIdentifier:@"Unknown Table"] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]);
}

- (void)testScrollingToTop
{
    [[viewTester table] tapRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [viewTester tapStatusBar];

    UITableView *tableView = (UITableView *)[viewTester table].view;
    [viewTester runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(tableView.contentOffset.y == - tableView.contentInset.top, error, @"Waited for scroll view to scroll to top, but it ended at %@", NSStringFromCGPoint(tableView.contentOffset));
        return KIFTestStepResultSuccess;
    }];
}

- (void)testTappingRowsByLabel
{
    // Tap the first row, which is already visible
    [[viewTester firstCell] tap];

    // Tap the last row, which will need to be scrolled up
    [[viewTester lastCell] tap];

    // Tap the first row, which will need to be scrolled down
    [[viewTester firstCell] tap];
}

- (void)testMoveRowDown
{
    [[viewTester editButton] tap];

    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 0", @"");
    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 4", @"");

    [[viewTester table] moveRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] toIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];

    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 1", @"");
    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 0", @"");

    [[viewTester doneButton] tap];
}

- (void)testMoveRowUp
{
    [[viewTester editButton] tap];

    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 0", @"");
    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 4", @"");

    [[viewTester table] moveRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];

    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text, @"Cell 4", @"");
    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]].textLabel.text, @"Cell 3", @"");

    [[viewTester doneButton] tap];
}

- (void)testMoveRowUpUsingNegativeRowIndexes
{
    [[viewTester editButton] tap];

    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-3 inSection:1]].textLabel.text, @"Cell 35", @"");
    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:1]].textLabel.text, @"Cell 37", @"");

    [[viewTester table] moveRowInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:1] toIndexPath:[NSIndexPath indexPathForRow:-3 inSection:1]];

    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-3 inSection:1]].textLabel.text, @"Cell 37", @"");
    __KIFAssertEqualObjects([[viewTester table] waitForCellInTableViewAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:1]].textLabel.text, @"Cell 36", @"");

    [[viewTester doneButton] tap];
}

- (void)testTogglingSwitch
{
    [[viewTester tableViewSwitch] setSwitchOn:NO];
    [[viewTester tableViewSwitch] setSwitchOn:YES];
}

- (void)testButtonAbsentAfterRemoveFromSuperview
{
    [[viewTester button] waitForView];

    [[viewTester button].view removeFromSuperview];
    [[viewTester button] waitForAbsenceOfView];
}

- (void)testButtonAbsentAfterSetHidden
{
    [[viewTester button] waitForView];

    UIView *button = [viewTester button].view;

    [button setHidden:YES];
    [[viewTester button] waitForAbsenceOfView];

    [button setHidden:NO];
    [[viewTester button] waitForView];
}

- (void)testEnteringTextIntoATextFieldInATableCell
{
    [[viewTester usingAccessibilityLabel:@"TextField"] enterText:@"Test-Driven Development"];
}

@end
