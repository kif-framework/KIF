//
//  AboutViewController.m
//  Calculator
//
//  Created by Brian Nickel on 12/14/12.
//  Copyright (c) 2012 Brian Nickel. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)init
{
    self = [super initWithNibName:@"AboutViewController" bundle:nil];
    if (self) {
        self.title = @"About";
    }
    return self;
}

@end
