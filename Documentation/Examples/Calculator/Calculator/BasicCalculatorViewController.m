//
//  ViewController.m
//  Calculator
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "BasicCalculatorViewController.h"

typedef NS_ENUM(NSInteger, CalculatorOperation) {
    Add,
    Subtract,
    Multiply,
    Divide
};

@interface BasicCalculatorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *input1;
@property (weak, nonatomic) IBOutlet UITextField *input2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *operationInput;
@property (weak, nonatomic) IBOutlet UILabel *output;

@end

@implementation BasicCalculatorViewController

- (id)init
{
    self = [super initWithNibName:@"BasicCalculatorViewController" bundle:nil];
    if (self) {
        self.title = @"Basic Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    for (int i = 0; i < self.operationInput.subviews.count; i++) {
        UIView *segment = (UIView *)self.operationInput.subviews[i];
        UIView *label = segment.subviews[0];
        NSString *segmentText = [(id)label text];

        if ([segmentText isEqualToString:@"+"]) {
            segment.accessibilityLabel = @"Add";
        } else if ([segmentText isEqualToString:@"–"]) {
            segment.accessibilityLabel = @"Subtract";
        } else if ([segmentText isEqualToString:@"×"]) {
            segment.accessibilityLabel = @"Multiply";
        } else if ([segmentText isEqualToString:@"÷"]) {
            segment.accessibilityLabel = @"Divide";
        } else {
            @throw([NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Invalid segment text value (%@)", segmentText] userInfo:nil]);
        }
    }
}

- (IBAction)recalculate
{
    double value1 = self.input1.text.doubleValue;
    double value2 = self.input2.text.doubleValue;
    double output;
    
    switch ((CalculatorOperation)self.operationInput.selectedSegmentIndex) {
        case Add:
            output = value1 + value2;
            break;
        case Subtract:
            output = value1 - value2;
            break;
        case Multiply:
            output = value1 * value2;
            break;
        case Divide:
            output = value1 / value2;
            break;
    }
    
    self.output.text = [NSString stringWithFormat:@"%.8f", output];
}

@end
