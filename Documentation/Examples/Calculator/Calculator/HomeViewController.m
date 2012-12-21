//
//  HomeViewController.m
//  Calculator
//
//  Created by Brian Nickel on 12/14/12.
//  Copyright (c) 2012 Brian Nickel. All rights reserved.
//

#import "HomeViewController.h"
#import "AboutViewController.h"
#import "BasicCalculatorViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)init
{
    self = [super initWithNibName:@"HomeViewController" bundle:nil];
    if (self) {
        self.title = @"Home";
    }
    return self;
}

- (IBAction)showBasicCalculator
{
    [self.navigationController pushViewController:[[BasicCalculatorViewController alloc] init] animated:YES];
}

- (IBAction)showAbout
{
    [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
}

@end
