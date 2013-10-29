
@interface PickerController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate>

@property (weak, nonatomic, readonly) IBOutlet UITextField *dateSelectionTextField;
@property (weak, nonatomic, readonly) IBOutlet UITextField *dateTimeSelectionTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIDatePicker *dateTimePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *phoneticPickerView;

@end

@implementation PickerController

@synthesize datePicker;
@synthesize dateTimePicker;
@synthesize dateSelectionTextField;
@synthesize dateTimeSelectionTextField;
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

    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerChanged:)
              forControlEvents:UIControlEventValueChanged];
    [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    dateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
    dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [dateTimePicker addTarget:self action:@selector(dateTimePickerChanged:)
         forControlEvents:UIControlEventValueChanged];
    [dateTimePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    dateSelectionTextField.placeholder = NSLocalizedString(@"Date Selection", nil);
    dateSelectionTextField.returnKeyType = UIReturnKeyDone;
    dateSelectionTextField.inputView = datePicker;
    dateSelectionTextField.accessibilityLabel = @"Date Selection";

    dateTimeSelectionTextField.placeholder = NSLocalizedString(@"Date Time Selection", nil);
    dateTimeSelectionTextField.returnKeyType = UIReturnKeyDone;
    dateTimeSelectionTextField.inputView = dateTimePicker;
    dateTimeSelectionTextField.accessibilityLabel = @"Date Time Selection";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(id)sender {
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *string = [NSString stringWithFormat:@"%@",
                        [dateFormatter stringFromDate:datePicker.date]];
    self.dateSelectionTextField.text = string;
}

- (void)dateTimePickerChanged:(id)sender {
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *string = [NSString stringWithFormat:@"%@",
                        [dateFormatter stringFromDate:dateTimePicker.date]];
    self.dateTimeSelectionTextField.text = string;
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
