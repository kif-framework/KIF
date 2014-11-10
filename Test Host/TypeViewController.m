//
//  TypeViewController.m
//  KIF
//
//  Created by Aaron Jubbal on 11/9/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNameTextFieldTag 1
#define kGreetingTextFieldTag 2

@interface TypeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *greetingTextField;
@property (weak, nonatomic) IBOutlet UIButton *resignFirstResponderButton;
@end

@implementation TypeViewController

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == kNameTextFieldTag) {
        [self.greetingTextField setText:[NSString stringWithFormat:@"Hello, %@!", self.nameTextField.text]];
    }
}

- (IBAction)resignFirstResponder:(UIButton *)button
{
    [self.nameTextField resignFirstResponder];
    [self.greetingTextField resignFirstResponder];
}

@end
