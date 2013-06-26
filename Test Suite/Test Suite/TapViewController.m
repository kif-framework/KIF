//
//  TapViewController.m
//  Test Suite
//
//  Created by Brian Nickel on 6/26/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *memoryWarningLabel;
@end

@implementation TapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
}

- (void)memoryWarningNotification:(NSNotification *)notification
{
    self.memoryWarningLabel.hidden = NO;
}

- (IBAction)hideMemoryWarning
{
    self.memoryWarningLabel.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
