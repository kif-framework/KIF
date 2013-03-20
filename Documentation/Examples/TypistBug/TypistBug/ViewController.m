//
//  ViewController.m
//  TypistBug
//
//  Created by Pete Hodgson on 3/20/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *exampleTextField;
@property (weak, nonatomic) IBOutlet UISwitch *capitalizationSwitch;

- (void) updateCapitalization;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateCapitalization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)capitalizationDidChange:(id)sender {
    [self updateCapitalization];
}

- (void) updateCapitalization{
    if( self.capitalizationSwitch.on ){
        self.exampleTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }else{
        self.exampleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
}

@end
