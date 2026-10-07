//
//  TapViewController.m
//  Test Suite
//
//  Created by Brian Nickel on 6/26/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIAccessibilityCustomAction.h>

@interface TapViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UILabel *lineBreakLabel;
@property (strong, nonatomic) UILabel *memoryWarningLabel;
@property (strong, nonatomic) UILabel *selectedPhotoClass;
@property (strong, nonatomic) UITextField *otherTextField;
@property (strong, nonatomic) UITextField *greetingTextField;
@property (strong, nonatomic) UIStepper *stepper;
@property (strong, nonatomic) UILabel *stepperValueLabel;
@property (strong, nonatomic) UISwitch *happySwitch;
@end

@implementation TapViewController

// Every text field on this screen is a 14pt rounded rect field, delegated to this controller, that keeps its distance from the top and bottom edges.
- (UITextField *)textFieldWithFrame:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    textField.opaque = NO;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:14];
    textField.minimumFontSize = 17;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.delegate = self;
    return textField;
}

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.adjustsImageWhenHighlighted = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:0.42467421293258667 green:0.42466151714324951 blue:0.42466866970062256 alpha:1] forState:UIControlStateNormal];
    if (action) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.opaque = NO;
    label.backgroundColor = nil;
    label.contentMode = UIViewContentModeLeft;
    label.text = text;
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkTextColor];
    return label;
}

- (void)loadView
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    // The storyboard decoded this as a plain view with a UIScrollView class, so it never got the scroll view defaults.
    view.clipsToBounds = NO;
    view.multipleTouchEnabled = NO;
    view.bouncesZoom = NO;
    view.backgroundColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];
    // Leave contentSize at zero. The out-of-frame text field must stay unreachable by scrolling,
    // which AccessibilityIdentifierTests relies on.

    // The greeting field below sits on top of this one, so later subview order matters here.
    UITextField *occludedField = [self textFieldWithFrame:CGRectMake(63, 136, 111, 29)];
    occludedField.text = @"Hello";
    occludedField.accessibilityHint = @"";
    occludedField.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    occludedField.accessibilityIdentifier = @"occludedView";
    [view addSubview:occludedField];

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"First", @"Second"]];
    segmentedControl.frame = CGRectMake(63, 37, 156, 29);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    segmentedControl.contentMode = UIViewContentModeScaleAspectFit;
    segmentedControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    segmentedControl.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisVertical];
    [view addSubview:segmentedControl];

    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(225, 37, 74, 29)];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.slider.maximumValue = 5;
    self.slider.accessibilityLabel = @"Slider";
    self.slider.accessibilityTraits = UIAccessibilityTraitNone;
    self.slider.accessibilityIdentifier = @"idSlider";
    [self.slider setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisVertical];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.slider];

    self.greetingTextField = [self textFieldWithFrame:CGRectMake(63, 136, 152, 29)];
    self.greetingTextField.text = @"Hello";
    self.greetingTextField.accessibilityLabel = @"Greeting";
    self.greetingTextField.accessibilityHint = @"";
    self.greetingTextField.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    self.greetingTextField.accessibilityIdentifier = @"idGreeting";
    [view addSubview:self.greetingTextField];

    UITextField *outOfFrameField = [self textFieldWithFrame:CGRectMake(131, 2000, 152, 29)];
    outOfFrameField.text = @"Hello";
    outOfFrameField.accessibilityHint = @"";
    outOfFrameField.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    outOfFrameField.accessibilityIdentifier = @"outOfFrameView";
    [view addSubview:outOfFrameField];

    UIButton *hideMemoryWarningButton = [self buttonWithFrame:CGRectMake(174, 533, 218, 46)
                                                        title:@"Hide memory warning"
                                                     fontSize:[UIFont buttonFontSize]
                                                       action:@selector(hideMemoryWarning)];
    hideMemoryWarningButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [view addSubview:hideMemoryWarningButton];

    self.memoryWarningLabel = [self labelWithFrame:CGRectMake(274, 506, 118, 22) text:@"Memory Critical"];
    self.memoryWarningLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    self.memoryWarningLabel.hidden = YES;
    [view addSubview:self.memoryWarningLabel];

    self.happySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(131, 204, 51, 31)];
    self.happySwitch.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.happySwitch.opaque = NO;
    self.happySwitch.on = YES;
    self.happySwitch.accessibilityLabel = @"Happy";
    self.happySwitch.accessibilityIdentifier = @"idHappy";
    [self.happySwitch setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    [self.happySwitch setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisVertical];
    [view addSubview:self.happySwitch];

    UIButton *xButton = [self buttonWithFrame:CGRectMake(0, -2, 35, 581) title:@"X" fontSize:[UIFont buttonFontSize] action:@selector(toggleSelected:)];
    xButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    xButton.accessibilityIdentifier = @"X_BUTTON";
    [view addSubview:xButton];

    self.otherTextField = [self textFieldWithFrame:CGRectMake(227, 111, 70, 29)];
    self.otherTextField.accessibilityLabel = @"Other Text";
    [view addSubview:self.otherTextField];

    UIScrollView *innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(43, 459, 254, 42)];
    innerScrollView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    innerScrollView.multipleTouchEnabled = YES;
    innerScrollView.accessibilityIdentifier = @"TapViewController Inner ScrollView";

    // Deliberately hangs past the right edge of the scroll view, so it's only partly visible.
    UIButton *innerButton = [self buttonWithFrame:CGRectMake(212, 6, 70, 31) title:@"Button" fontSize:15 action:NULL];
    innerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    innerButton.accessibilityLabel = @"Slightly Offscreen Button";
    innerButton.accessibilityIdentifier = @"Inner Button";
    [innerScrollView addSubview:innerButton];
    [view addSubview:innerScrollView];

    UILabel *gestureLabel = [self labelWithFrame:CGRectMake(23, 586, 365, 20) text:@"Label with Tap Gesture Recognizer"];
    gestureLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    gestureLabel.userInteractionEnabled = YES;
    gestureLabel.numberOfLines = 2;
    [gestureLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [gestureLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [gestureLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    [view addSubview:gestureLabel];

    UILabel *lineBreakTextLabel = [self labelWithFrame:CGRectMake(23, 615, 365, 42) text:@"Label with\nLine Break\n\n"];
    lineBreakTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    lineBreakTextLabel.userInteractionEnabled = YES;
    lineBreakTextLabel.numberOfLines = 2;
    [lineBreakTextLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [lineBreakTextLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [view addSubview:lineBreakTextLabel];

    self.lineBreakLabel = [self labelWithFrame:CGRectMake(23, 664, 365, 20) text:@"Label with code setting Line Breaks"];
    self.lineBreakLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.lineBreakLabel.userInteractionEnabled = YES;
    [self.lineBreakLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.lineBreakLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [view addSubview:self.lineBreakLabel];

    UIButton *animationsButton = [self buttonWithFrame:CGRectMake(43, 207, 101, 26) title:@"Animations" fontSize:15 action:@selector(showAnimations:)];
    animationsButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:animationsButton];

    self.stepper = [[UIStepper alloc] initWithFrame:CGRectMake(160, 411, 94, 23)];
    self.stepper.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.stepper.opaque = NO;
    self.stepper.maximumValue = 100;
    self.stepper.value = 50;
    self.stepper.accessibilityIdentifier = @"tapViewController.stepper";
    [self.stepper setContentHuggingPriority:750 forAxis:UILayoutConstraintAxisHorizontal];
    [self.stepper setContentHuggingPriority:750 forAxis:UILayoutConstraintAxisVertical];
    [self.stepper addTarget:self action:@selector(stepperValueChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.stepper];

    self.stepperValueLabel = [self labelWithFrame:CGRectMake(102, 411, 42, 21) text:@"50"];
    self.stepperValueLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.stepperValueLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.stepperValueLabel.textAlignment = NSTextAlignmentCenter;
    self.stepperValueLabel.accessibilityLabel = @"stepperValue";
    self.stepperValueLabel.accessibilityIdentifier = @"tapViewController.stepperValue";
    [self.stepperValueLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.stepperValueLabel setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [view addSubview:self.stepperValueLabel];

    self.selectedPhotoClass = [self labelWithFrame:CGRectMake(27, 463, 277, 21) text:@"Selected Image class"];
    self.selectedPhotoClass.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.selectedPhotoClass setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self.selectedPhotoClass setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [view addSubview:self.selectedPhotoClass];

    // A decoy for the back button: same label, but a keyboard key rather than a button, so tests can tell them apart.
    UIButton *decoyBackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    decoyBackButton.frame = CGRectMake(285, 205, 68, 30);
    decoyBackButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    decoyBackButton.adjustsImageWhenHighlighted = YES;
    [decoyBackButton setTitle:@"Test Suite" forState:UIControlStateNormal];
    decoyBackButton.accessibilityTraits = UIAccessibilityTraitKeyboardKey;
    [view addSubview:decoyBackButton];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    self.lineBreakLabel.accessibilityLabel = @"A\nB\nC\n\n";
	self.stepper.isAccessibilityElement = YES;
	self.stepper.accessibilityLabel = @"theStepper";

    // This screen is laid out with autoresizing masks, so its subviews shift by different
    // amounts as the navigation bar height changes between iOS versions. On iOS 26 the taller
    // bar moves the inner scroll view up on top of the switch, which stops the switch being
    // hittable. Keeping the switch in front leaves it tappable whatever the bar height is.
    [self.view bringSubviewToFront:self.happySwitch];
}

- (void)memoryWarningNotification:(NSNotification *)notification
{
    self.memoryWarningLabel.hidden = NO;
}

- (void)hideMemoryWarning
{
    self.memoryWarningLabel.hidden = YES;
}

- (void)toggleSelected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.slider.value = self.slider.value + 1;
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.slider.value = self.slider.value - 1;
    });
}

- (void)sliderValueChanged:(UISlider *)sender
{
    sender.accessibilityValue = [NSString stringWithFormat:@"%d", (int)roundf(sender.value)];
}

- (void)showAnimations:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"showAnimations" sender:sender];
}

- (IBAction)pickPhoto:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)stepperValueChanged:(UIStepper *)sender forEvent:(UIEvent *)event
{
	self.stepperValueLabel.text = [NSString stringWithFormat:@"%ld", (long)sender.value];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.otherTextField) {
        [self.greetingTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.otherTextField && range.length != 0) {
        self.greetingTextField.text = @"Deleted something.";
    }
    
    return YES;
}




#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.selectedPhotoClass.text = NSStringFromClass([info[UIImagePickerControllerOriginalImage] class]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
