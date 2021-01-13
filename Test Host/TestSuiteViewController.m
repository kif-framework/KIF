//
//  TestSuiteViewController.m
//  Test Suite
//
//  Created by Brian K Nickel on 6/26/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSuiteViewController : UITableViewController <UIActionSheetDelegate>
@end

@implementation TestSuiteViewController

-(void) viewDidLoad
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

- (void) setupRefreshControl
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1) {
        return;
    }

    switch (indexPath.row) {
        case 0:
        {
            [[[UIAlertView alloc] initWithTitle:@"Alert View" message:@"Message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil] show];
            break;
        }

        case 1:
        {
            break;
        }

        case 2:
        {
            [[[UIActionSheet alloc] initWithTitle:@"Action Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Destroy" otherButtonTitles:@"A", @"B", nil] showInView:tableView];
            break;
        }

        case 3:
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
}

-(void)pullToRefreshHandler
{
	self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Bingo!", @"") attributes:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self.tableView setContentOffset:CGPointZero animated:YES];
    });
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Alert View"
                                                                              message:@"Message"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)resetRefreshControl
{
	self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing...", @"") attributes:nil];
}
@end
