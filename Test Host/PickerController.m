
@interface PickerController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate>

@property (weak, nonatomic, readonly) IBOutlet UITextField *dateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *birthdatePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) IBOutlet UIPickerView *phoneticPickerView;

@end

@implementation PickerController

@synthesize birthdatePicker;
@synthesize dateSelectionTextField;
@synthesize dateFormatter;
@synthesize phoneticPickerView;

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
    birthdatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
    birthdatePicker.datePickerMode = UIDatePickerModeDate;
    [birthdatePicker addTarget:self action:@selector(datePickerChanged:)
              forControlEvents:UIControlEventValueChanged];
    [birthdatePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    dateSelectionTextField.placeholder = NSLocalizedString(@"Birthdate", nil);
    dateSelectionTextField.returnKeyType = UIReturnKeyDone;
    dateSelectionTextField.inputView = birthdatePicker;
    dateSelectionTextField.accessibilityLabel = @"Date Selection";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(id)sender {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    NSString *string = [NSString stringWithFormat:@"%@",
                        [dateFormatter stringFromDate:birthdatePicker.date]];
    self.dateSelectionTextField.text = string;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [@[@"Alpha", @"Bravo", @"Charlie"] objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView accessibilityLabelForComponent:(NSInteger)component
{
    return @"Call Sign";
}

@end
