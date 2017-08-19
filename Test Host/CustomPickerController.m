//
//  CustomPickerController.m
//  KIF
//
//  Created by Deepakkumar Sharma on 18/08/17.
//
//

#import <Foundation/Foundation.h>

#pragma mark PickerDelegate
@interface PickerDelegate : NSObject<UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate>

-(instancetype)initWithInputTextField:(UITextField*)textField;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation PickerDelegate

-(instancetype)initWithInputTextField:(UITextField *)inputTextField {
    self = [super init];
    self.textField = inputTextField;
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView accessibilityLabelForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return @"red";
            break;
        case 1:
            return @"green";
            break;
        case 2:
            return @"blue";
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger red = [pickerView selectedRowInComponent:0];
    NSInteger green = [pickerView selectedRowInComponent:1];
    NSInteger blue = [pickerView selectedRowInComponent:2];
    NSString *text = [NSString stringWithFormat:@"%li%li%li",red,green,blue];
    [self.textField setText:text];
}

@end

#pragma mark CustomLabelPickerDelegate
@interface CustomLabelPickerDelegate : PickerDelegate

@end

@implementation CustomLabelPickerDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view == nil) {
        view = [[UILabel alloc] init];
    }

    UILabel *label = (UILabel *)view;
    label.text = [NSString stringWithFormat:@"%li", (long)row];
    label.textAlignment = NSTextAlignmentCenter;

    switch (component) {
        case 0:
            label.backgroundColor = [UIColor redColor];
            break;
        case 1:
            label.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            label.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }

    return label;
}

@end

#pragma mark AttributedTitlePickerDelegate
@interface AttributedTitlePickerDelegate : PickerDelegate

@end

@implementation AttributedTitlePickerDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIColor *textColor;
    switch (component) {
        case 0:
            textColor = [UIColor redColor];
            break;
        case 1:
            textColor = [UIColor greenColor];
            break;
        case 2:
            textColor = [UIColor blueColor];
            break;
        default:
            textColor = [UIColor blackColor];
            break;
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *attributes = @{NSForegroundColorAttributeName : textColor};
    NSString *title = [NSString stringWithFormat:@"%li", (long)row];

    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

@end

#pragma mark CustomPickerController
@interface CustomPickerController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *customLabelSelectionTextField;
@property (weak, nonatomic) IBOutlet UITextField *attributedTitleSelectionTextField;
@property (strong, nonatomic) UIPickerView *customLabelPicker;
@property (strong, nonatomic) UIPickerView *attributedTitlePicker;
@property (strong, nonatomic) PickerDelegate *customLabelPickerDelegate;
@property (strong, nonatomic) PickerDelegate *attributedTitlePickerDelegate;

@end

@implementation CustomPickerController

@synthesize customLabelPicker;
@synthesize customLabelSelectionTextField;
@synthesize attributedTitlePicker;
@synthesize attributedTitleSelectionTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    customLabelPicker = [[UIPickerView alloc] init];
    self.customLabelPickerDelegate = [[CustomLabelPickerDelegate alloc] initWithInputTextField:customLabelSelectionTextField];
    customLabelPicker.delegate = self.customLabelPickerDelegate;
    customLabelPicker.dataSource = self.customLabelPickerDelegate;

    customLabelSelectionTextField.placeholder = NSLocalizedString(@"Custom Label Selection", nil);
    customLabelSelectionTextField.inputView = customLabelPicker;
    customLabelSelectionTextField.accessibilityLabel = @"Custom Label Selection";

    attributedTitlePicker = [[UIPickerView alloc] init];
    self.attributedTitlePickerDelegate = [[AttributedTitlePickerDelegate alloc] initWithInputTextField:attributedTitleSelectionTextField];
    attributedTitlePicker.delegate = self.attributedTitlePickerDelegate;
    attributedTitlePicker.dataSource = self.attributedTitlePickerDelegate;

    attributedTitleSelectionTextField.placeholder = NSLocalizedString(@"Attributed Title Selection", nil);
    attributedTitleSelectionTextField.inputView = attributedTitlePicker;
    attributedTitleSelectionTextField.accessibilityLabel = @"Attributed Title Selection";
}

@end
