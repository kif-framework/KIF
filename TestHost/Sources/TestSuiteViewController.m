//
//  TestSuiteViewController.m
//  Test Suite
//
//  Created by Brian K Nickel on 6/26/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestHost-Swift.h"

@interface TestSuiteViewController : UITableViewController
@property (copy, nonatomic) NSArray<NSString *> *sectionTitles;
@property (copy, nonatomic) NSArray<NSArray<UITableViewCell *> *> *cells;
@property (copy, nonatomic) NSArray<NSString *> *basicsViewControllerClassNames;
@end

@implementation TestSuiteViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Master";
        self.navigationItem.title = @"Test Suite";

        UISwitch *switch1 = [[UISwitch alloc] initWithFrame:CGRectMake(343, 6.5, 51, 31)];
        switch1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        switch1.opaque = NO;
        switch1.on = YES;
        switch1.accessibilityLabel = @"Switch 1";
        [switch1 setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
        [switch1 setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisVertical];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switch1];

        self.toolbarItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Reset Refresh Control" style:UIBarButtonItemStylePlain target:self action:@selector(resetRefreshControl)]];
    }
    return self;
}

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
    tableView.accessibilityIdentifier = @"Test Suite TableView";

    // The menu is static: every row has exactly one cell, created here and never reused or replaced.
    // Rows in the Basics section push the view controller with the matching class name.
    self.sectionTitles = @[@"Basics", @"Modal Views", @"SwiftUI"];
    self.basicsViewControllerClassNames = @[@"TapViewController", @"ShowHideViewController", @"GestureViewController", @"TableViewController",
                                            @"CollectionViewController", @"ScrollViewController", @"PickerController", @"WebViewController",
                                            @"BackgroundViewController", @"CustomPickerController", @"OffscreenViewController", @"AccessibilityViewController"];
    self.cells = @[
        @[[self textCellWithText:@"Tapping"],
          [self textCellWithText:@"Show/Hide"],
          [self textCellWithText:@"Gestures"],
          [self textCellWithText:@"TableViews"],
          [self textCellWithText:@"CollectionViews"],
          [self textCellWithText:@"ScrollViews"],
          [self labelCellWithText:@"Pickers" labelSize:CGSizeMake(106, 21)],
          [self labelCellWithText:@"WebViews" labelSize:CGSizeMake(106, 24)],
          [self labelCellWithText:@"Background" labelSize:CGSizeMake(113, 24)],
          [self labelCellWithText:@"Custom Picker" labelSize:CGSizeMake(176, 24)],
          [self labelCellWithText:@"Offscreen Views" labelSize:CGSizeMake(176, 24)],
          [self labelCellWithText:@"Accessibility" labelSize:CGSizeMake(176, 24)]],
        @[[self labelCellWithText:@"System Alerts" labelSize:CGSizeMake(128, 24)],
          [self textCellWithText:@"UIAlertController"],
          [self textCellWithText:@"UIActivityViewController"]],
        @[[self textCellWithText:@"SwiftUI Tapping"],
          [self textCellWithText:@"SwiftUI Typing"]],
    ];

    tableView.dataSource = self;
    tableView.delegate = self;

    self.tableView = tableView;
}

- (UITableViewCell *)disclosureCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.contentView.opaque = NO;
    cell.contentView.clipsToBounds = YES;
    cell.contentView.multipleTouchEnabled = YES;
    cell.contentView.contentMode = UIViewContentModeCenter;
    return cell;
}

- (UITableViewCell *)textCellWithText:(NSString *)text
{
    UITableViewCell *cell = [self disclosureCellWithReuseIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.indentationLevel = 1;
    cell.indentationWidth = 0;
    cell.textLabel.opaque = NO;
    cell.textLabel.userInteractionEnabled = YES;
    cell.textLabel.multipleTouchEnabled = YES;
    cell.textLabel.contentMode = UIViewContentModeCenter;
    cell.textLabel.backgroundColor = nil;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];
    return cell;
}

- (UITableViewCell *)labelCellWithText:(NSString *)text labelSize:(CGSize)labelSize
{
    UITableViewCell *cell = [self disclosureCellWithReuseIdentifier:nil];
    cell.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.indentationWidth = 10;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, labelSize.width, labelSize.height)];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    label.opaque = NO;
    label.userInteractionEnabled = NO;
    label.backgroundColor = nil;
    label.contentMode = UIViewContentModeLeft;
    label.text = text;
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    label.textColor = [UIColor darkTextColor];
    label.textAlignment = NSTextAlignmentLeft;
    [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [cell.contentView addSubview:label];
    return cell;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	//set up an accessibility label on the table.
	self.tableView.isAccessibilityElement = YES;
	self.tableView.accessibilityLabel = @"Table View";
    
    // memory warning was causing cells to disappear on static table views, reloading lets them come back
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRefreshControl
{
	self.refreshControl = [[UIRefreshControl alloc] init];
	self.refreshControl.backgroundColor = [UIColor grayColor];
	self.refreshControl.tintColor = [UIColor whiteColor];
	[self.refreshControl addTarget:self
							action:@selector(pullToRefreshHandler)
				  forControlEvents:UIControlEventValueChanged];
	self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing...", @"") attributes:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	dispatch_async(dispatch_get_main_queue(), ^{
        [self setupRefreshControl];
	});
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

- (void)pushViewControllerWithClassName:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: // Basics section
            [self pushViewControllerWithClassName:self.basicsViewControllerClassNames[indexPath.row]];
            break;
        case 1: // Modal views section
            switch (indexPath.row) {
                case 0:
                {
                    [self pushViewControllerWithClassName:@"SystemAlertViewController"];
                    break;
                }
                    
                case 1:
                {
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Alert Controller"
                                                          message:@""
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *destroyAction = [UIAlertAction actionWithTitle:@"Destroy" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [self alertControllerDismissed];
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self alertControllerDismissed];
                    }];
                    
                    [alertController addAction:destroyAction];
                    [alertController addAction:[self alertActionWithTitle:@"A"]];
                    [alertController addAction:[self alertActionWithTitle:@"B"]];
                    [alertController addAction:cancelAction];
                    
                    if ([alertController respondsToSelector:@selector(popoverPresentationController)] && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                        // iOS 8 iPad presents in a popover
                        alertController.popoverPresentationController.sourceView = [tableView cellForRowAtIndexPath:indexPath];
                        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:alertController];
                        [popover presentPopoverFromRect:alertController.popoverPresentationController.sourceView.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    } else {
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    break;
                }
                    
                case 2:
                {
                    Class AVCClass = NSClassFromString(@"UIActivityViewController");
                    if (AVCClass) {
                        UIActivityViewController *controller = [[AVCClass alloc] initWithActivityItems:@[@"Hello World"] applicationActivities:nil];
                        
                        if ([controller respondsToSelector:@selector(popoverPresentationController)] && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            // iOS 8 iPad presents in a popover
                            controller.popoverPresentationController.sourceView = [tableView cellForRowAtIndexPath:indexPath];
                            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
                            [popover presentPopoverFromRect:controller.popoverPresentationController.sourceView.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                        } else {
                            [self presentViewController:controller animated:YES completion:nil];
                        }
                    }
                    break;
                }
            }
            return;
        case 2: // SwiftUI section
            switch (indexPath.row) {
                case 0:
                {
                    [[self navigationController] pushViewController:[SwiftUIViewControllerFactory makeSwiftUITappingViewController] animated:true];
                    break;
                }
                
                case 1:
                {
                    [[self navigationController] pushViewController:[SwiftUIViewControllerFactory makeSwiftUITypingViewController] animated:true];
                    break;
                }
            }
    }
}

-(void)pullToRefreshHandler
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Bingo!", @"") attributes:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self resetRefreshControl];
            [self.tableView setContentOffset:CGPointZero animated:YES];
        });
    });
}

- (void)alertControllerDismissed
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Alert View"
                                                                              message:@"Message"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(UIAlertAction *)alertActionWithTitle:(NSString *)title
{
    return [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alertControllerDismissed];
    }];
}

- (void)resetRefreshControl
{
	self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing...", @"") attributes:nil];
}
@end
