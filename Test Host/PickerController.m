
@interface PickerController : UIViewController
@property (weak, nonatomic, readonly) IBOutlet UITextField *dateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *birthdatePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerViewComponent;

@end

@implementation PickerController
@synthesize birthdatePicker;
@synthesize dateSelectionTextField;
@synthesize dateFormatter;
@synthesize pickerViewComponent;


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
@end
