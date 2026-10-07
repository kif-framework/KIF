//
//  TableViewController.m
//  KIF
//
//  Created by Hilton Campbell on 4/12/14.
//
//

@interface TableViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (copy, nonatomic) NSArray<NSString *> *sectionTitles;
@property (copy, nonatomic) NSArray<NSArray<UITableViewCell *> *> *cells;

@end

@implementation TableViewController

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 414, 804) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.opaque = NO;
    tableView.clipsToBounds = YES;
    tableView.clearsContextBeforeDrawing = NO;
    tableView.alwaysBounceVertical = YES;
    tableView.backgroundColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];
    tableView.rowHeight = 44;
    tableView.sectionHeaderHeight = 22;
    tableView.sectionFooterHeight = 22;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.accessibilityIdentifier = @"TableView Tests Table";

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 414, 44)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.searchBar.opaque = NO;
    // Without an explicit translucency setting, the search bar makes itself opaque when it lays out.
    self.searchBar.translucent = YES;
    self.searchBar.contentMode = UIViewContentModeRedraw;
    [self.searchBar setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisVertical];
    [self.searchBar sizeToFit];
    tableView.tableHeaderView = self.searchBar;

    UISwitch *tableViewSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 8, 51, 31)];
    tableViewSwitch.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    tableViewSwitch.opaque = NO;
    tableViewSwitch.on = YES;
    tableViewSwitch.accessibilityLabel = @"Table View Switch";

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 7, 304, 30)];
    textField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    textField.opaque = NO;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:14];
    textField.minimumFontSize = 17;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.accessibilityLabel = @"TextField";

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(11, 8, 72, 29);
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    button.adjustsImageWhenHighlighted = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [button setTitle:@"Button" forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:0.42467421293258667 green:0.42466151714324951 blue:0.42466866970062256 alpha:1] forState:UIControlStateNormal];

    NSMutableArray<UITableViewCell *> *numberedCells = [NSMutableArray array];
    for (NSInteger i = 0; i < 38; i++) {
        [numberedCells addObject:[self textCellWithText:[NSString stringWithFormat:@"Cell %ld", (long)i]]];
    }

    // The table is static: every row has exactly one cell, created here and never reused or replaced, so the
    // tests can rely on a cell keeping its state (such as a "Deleted" label) when it scrolls offscreen and back.
    self.sectionTitles = @[@"Section-1", @"Section-2", @"Section-3"];
    self.cells = @[
        @[[self textCellWithText:@"First Cell"], [self controlCellWithControl:tableViewSwitch], [self controlCellWithControl:textField]],
        numberedCells,
        @[[self controlCellWithControl:button], [self textCellWithText:@"Last Cell"]],
    ];

    tableView.dataSource = self;
    tableView.delegate = self;

    self.tableView = tableView;
}

- (UITableViewCell *)emptyCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.contentView.opaque = NO;
    cell.contentView.clipsToBounds = YES;
    cell.contentView.multipleTouchEnabled = YES;
    cell.contentView.contentMode = UIViewContentModeCenter;
    return cell;
}

- (UITableViewCell *)textCellWithText:(NSString *)text
{
    UITableViewCell *cell = [self emptyCell];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.indentationLevel = 1;
    cell.indentationWidth = 0;
    cell.textLabel.opaque = NO;
    cell.textLabel.multipleTouchEnabled = YES;
    cell.textLabel.backgroundColor = nil;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];
    return cell;
}

- (UITableViewCell *)controlCellWithControl:(UIControl *)control
{
    UITableViewCell *cell = [self emptyCell];
    cell.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.indentationWidth = 10;
    [cell.contentView addSubview:control];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // Need to set this explicitly, as the default is different between iPhone and iPad and the value is ignored if set explicitly to "none"
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells[section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // Do nothing, this method is needed to activate reordering in edit mode
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

// Work around a bug on iOS9+ that accessibility trait Selected doesn't get set
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessibilityTraits:cell.accessibilityTraits | UIAccessibilityTraitSelected];

    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessibilityTraits:cell.accessibilityTraits ^ UIAccessibilityTraitSelected];
    
    return indexPath;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Since the table view uses static cells, it is not possible to remove the row,
        // so let's just change the label to have something to check in unit tests
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"Deleted";
        [self.tableView setEditing:NO animated:YES];
        
        // NOTE: These don't work very well
        // [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // [self.tableView reloadData];
    }
    
}

@end
