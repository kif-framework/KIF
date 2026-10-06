
@interface PickerController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate>

@property (strong, nonatomic) UITextField *wheelDateSelectionTextField;
@property (strong, nonatomic) UITextField *wheelDateTimeSelectionTextField;
@property (strong, nonatomic) UITextField *wheelTimeZoneDateTimeSelectionTextField;
@property (strong, nonatomic) UITextField *wheelLimitedDateTimeSelectionTextField;
@property (strong, nonatomic) UITextField *wheelTimeSelectionTextField;
@property (strong, nonatomic) UITextField *countdownSelectionTextField;
@property (strong, nonatomic) UITextField *datePickerCalendarTextField;
@property (strong, nonatomic) UITextField *dateTimePickerCalendarTextField;
@property (strong, nonatomic) UIDatePicker *wheelDatePicker;
@property (strong, nonatomic) UIDatePicker *wheelDateTimePicker;
@property (strong, nonatomic) UIDatePicker *wheelTimeZoneDateTimePicker;
@property (strong, nonatomic) UIDatePicker *wheelLimitedDateTimePicker;
@property (strong, nonatomic) UIDatePicker *wheelTimePicker;
@property (strong, nonatomic) UIDatePicker *countdownPicker;
@property (strong, nonatomic) UIDatePicker *dateCalendarPicker;
@property (strong, nonatomic) UIDatePicker *dateTimeCalendarPicker;
@property (strong, nonatomic) UIPickerView *phoneticPickerView;

@end

@implementation PickerController

@synthesize wheelDatePicker;
@synthesize wheelDateTimePicker;
@synthesize wheelTimeZoneDateTimePicker;
@synthesize wheelLimitedDateTimePicker;
@synthesize countdownPicker;
@synthesize wheelTimePicker;
@synthesize wheelDateSelectionTextField;
@synthesize wheelDateTimeSelectionTextField;
@synthesize wheelTimeZoneDateTimeSelectionTextField;
@synthesize wheelLimitedDateTimeSelectionTextField;
@synthesize wheelTimeSelectionTextField;
@synthesize countdownSelectionTextField;
@synthesize phoneticPickerView;

// Placeholders and input views are filled in by -viewDidLoad.
static UITextField *SelectionTextField(CGRect frame)
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:14];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.minimumFontSize = 17;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return textField;
}

- (void)loadView
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.multipleTouchEnabled = YES;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor colorWithRed:0.98763227462768555 green:0.31666561961174011 blue:0.76941287517547607 alpha:1];

    wheelDateSelectionTextField = SelectionTextField(CGRectMake(0, 0, 320, 30));
    [view addSubview:wheelDateSelectionTextField];

    wheelDateTimeSelectionTextField = SelectionTextField(CGRectMake(0, 32, 320, 30));
    [view addSubview:wheelDateTimeSelectionTextField];

    wheelLimitedDateTimeSelectionTextField = SelectionTextField(CGRectMake(0, 131, 320, 30));
    [view addSubview:wheelLimitedDateTimeSelectionTextField];

    wheelTimeSelectionTextField = SelectionTextField(CGRectMake(0, 65, 320, 30));
    [view addSubview:wheelTimeSelectionTextField];

    countdownSelectionTextField = SelectionTextField(CGRectMake(0, 98, 320, 30));
    [view addSubview:countdownSelectionTextField];

    self.datePickerCalendarTextField = SelectionTextField(CGRectMake(0, 169, 320, 34));
    self.datePickerCalendarTextField.textAlignment = NSTextAlignmentNatural;
    [view addSubview:self.datePickerCalendarTextField];

    self.dateTimePickerCalendarTextField = SelectionTextField(CGRectMake(0, 211, 320, 34));
    self.dateTimePickerCalendarTextField.textAlignment = NSTextAlignmentNatural;
    [view addSubview:self.dateTimePickerCalendarTextField];

    wheelTimeZoneDateTimeSelectionTextField = SelectionTextField(CGRectMake(0, 253, 320, 34));
    [view addSubview:wheelTimeZoneDateTimeSelectionTextField];

    phoneticPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(-1, 300, 412, 162)];
    phoneticPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    phoneticPickerView.backgroundColor = [UIColor colorWithRed:0.14493817090988159 green:1 blue:0.025771163403987885 alpha:1];
    phoneticPickerView.dataSource = self;
    phoneticPickerView.delegate = self;
    [view addSubview:phoneticPickerView];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    wheelDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
    wheelDatePicker.datePickerMode = UIDatePickerModeDate;
    
#if __IPHONE_13_4
    if(@available(iOS 13.4, *)) {
        wheelDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
#endif
    wheelDatePicker.hidden = NO;
    [wheelDatePicker addTarget:self action:@selector(datePickerChanged:)
              forControlEvents:UIControlEventValueChanged];
    [wheelDatePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    wheelDateSelectionTextField.placeholder = NSLocalizedString(@"Date Selection", nil);
    wheelDateSelectionTextField.returnKeyType = UIReturnKeyDone;
    wheelDateSelectionTextField.inputView = wheelDatePicker;
    wheelDateSelectionTextField.accessibilityLabel = @"Date Selection";

    wheelDateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
#if __IPHONE_13_4
    if(@available(iOS 13.4, *)) {
        wheelDateTimePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
#endif
    wheelDateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [wheelDateTimePicker addTarget:self action:@selector(dateTimePickerChanged:)
         forControlEvents:UIControlEventValueChanged];
    [wheelDateTimePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    wheelDateTimeSelectionTextField.placeholder = NSLocalizedString(@"Date Time Selection", nil);
    wheelDateTimeSelectionTextField.returnKeyType = UIReturnKeyDone;
    wheelDateTimeSelectionTextField.inputView = wheelDateTimePicker;
    wheelDateTimeSelectionTextField.accessibilityLabel = @"Date Time Selection";
    
    wheelTimeZoneDateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
    wheelTimeZoneDateTimePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
#if __IPHONE_13_4
    if(@available(iOS 13.4, *)) {
        wheelTimeZoneDateTimePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
#endif
    wheelTimeZoneDateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [wheelTimeZoneDateTimePicker addTarget:self action:@selector(timeZoneDateTimePickerChanged:)
                  forControlEvents:UIControlEventValueChanged];
    [wheelTimeZoneDateTimePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    wheelTimeZoneDateTimeSelectionTextField.placeholder = NSLocalizedString(@"Time Zone Date Time Selection", nil);
    wheelTimeZoneDateTimeSelectionTextField.returnKeyType = UIReturnKeyDone;
    wheelTimeZoneDateTimeSelectionTextField.inputView = wheelTimeZoneDateTimePicker;
    wheelTimeZoneDateTimeSelectionTextField.accessibilityLabel = @"Time Zone Date Time Selection";

    wheelLimitedDateTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
#if __IPHONE_13_4
    if(@available(iOS 13.4, *)) {
        wheelLimitedDateTimePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
#endif
    wheelLimitedDateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    wheelLimitedDateTimePicker.minimumDate = [NSDate dateWithTimeInterval:-31622400 /*Year+1day*/ sinceDate:[NSDate date]];
    wheelLimitedDateTimePicker.maximumDate = [NSDate dateWithTimeInterval: 31622400 /*Year+1day*/ sinceDate:[NSDate date]];
    [wheelLimitedDateTimePicker addTarget:self action:@selector(limitedDateTimePickerChanged:)
             forControlEvents:UIControlEventValueChanged];
    [wheelLimitedDateTimePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    wheelLimitedDateTimeSelectionTextField.placeholder = NSLocalizedString(@"Limited Date Time Selection", nil);
    wheelLimitedDateTimeSelectionTextField.returnKeyType = UIReturnKeyDone;
    wheelLimitedDateTimeSelectionTextField.inputView = wheelLimitedDateTimePicker;
    wheelLimitedDateTimeSelectionTextField.accessibilityLabel = @"Limited Date Time Selection";
    
    wheelTimePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
#if __IPHONE_13_4
    if(@available(iOS 13.4, *)) {
        wheelTimePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
#endif
    wheelTimePicker.datePickerMode = UIDatePickerModeTime;
    [wheelTimePicker addTarget:self action:@selector(timePickerChanged:)
             forControlEvents:UIControlEventValueChanged];
    [wheelTimePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    wheelTimeSelectionTextField.placeholder = NSLocalizedString(@"Time Selection", nil);
    wheelTimeSelectionTextField.returnKeyType = UIReturnKeyDone;
    wheelTimeSelectionTextField.inputView = wheelTimePicker;
    wheelTimeSelectionTextField.accessibilityLabel = @"Time Selection";

    countdownPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(30, 215, 260, 35)];
    countdownPicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [countdownPicker addTarget:self action:@selector(countdownPickerChanged:)
         forControlEvents:UIControlEventValueChanged];
    [countdownPicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    countdownSelectionTextField.placeholder = NSLocalizedString(@"Countdown Selection", nil);
    countdownSelectionTextField.returnKeyType = UIReturnKeyDone;
    countdownSelectionTextField.inputView = countdownPicker;
    countdownSelectionTextField.accessibilityLabel = @"Countdown Selection";
    
    self.dateCalendarPicker = [[UIDatePicker alloc] init];
    self.dateCalendarPicker.datePickerMode = UIDatePickerModeDate;
    [self.dateCalendarPicker addTarget:self action:@selector(dateCalendarPickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.dateCalendarPicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
#if __IPHONE_13_4
    if(@available(iOS 13.4, *)) {
        self.dateCalendarPicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
    }
#endif
    
    self.datePickerCalendarTextField.placeholder = NSLocalizedString(@"Date Calendar Selection", nil);
    self.datePickerCalendarTextField.returnKeyType = UIReturnKeyDone;
    self.datePickerCalendarTextField.inputView = self.dateCalendarPicker;
    self.datePickerCalendarTextField.accessibilityLabel = @"Date Calendar Selection";
    
    self.dateTimeCalendarPicker = [[UIDatePicker alloc] init];
    self.dateTimeCalendarPicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateTimeCalendarPicker addTarget:self action:@selector(dateTimeCalendarPickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.dateTimeCalendarPicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
#if __IPHONE_13_4
    if(@available(iOS 13.4, *)) {
        self.dateTimeCalendarPicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
    }
#endif
    
    self.dateTimePickerCalendarTextField.placeholder = NSLocalizedString(@"Date Time Calendar Selection", nil);
    self.dateTimePickerCalendarTextField.returnKeyType = UIReturnKeyDone;
    self.dateTimePickerCalendarTextField.inputView = self.dateTimeCalendarPicker;
    self.dateTimePickerCalendarTextField.accessibilityLabel = @"Date Time Calendar Selection";
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    });
    
    return dateFormatter;
}

- (void)datePickerChanged:(UIDatePicker *)picker {
    self.wheelDateSelectionTextField.text = [self.dateFormatter stringFromDate:picker.date];
}

- (NSDateFormatter *)dateTimeFormatter
{
    static NSDateFormatter *dateTimeFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        [dateTimeFormatter setDateFormat:@"MMM d, hh:mm aa"];
    });
    
    return dateTimeFormatter;
}

- (void)dateTimePickerChanged:(UIDatePicker *)picker
{
    self.wheelDateTimeSelectionTextField.text = [self.dateTimeFormatter stringFromDate:picker.date];
}

- (void)limitedDateTimePickerChanged:(UIDatePicker *)picker
{
    self.wheelLimitedDateTimeSelectionTextField.text = [self.dateTimeFormatter stringFromDate:picker.date];
}

- (NSDateFormatter *)timeZoneDateTimeFormatter
{
    static NSDateFormatter *dateTimeFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        dateTimeFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dateTimeFormatter setDateFormat:@"MMM d, hh:mm aa Z"];
    });
    
    return dateTimeFormatter;
}

- (void)timeZoneDateTimePickerChanged:(UIDatePicker *)picker
{
    self.wheelTimeZoneDateTimeSelectionTextField.text = [self.timeZoneDateTimeFormatter stringFromDate:picker.date];
}

- (NSDateFormatter *)timeFormatter
{
    static NSDateFormatter *timeFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"h:mm a"];
    });
    
    return timeFormatter;
}

- (void)timePickerChanged:(UIDatePicker *)picker
{
    self.wheelTimeSelectionTextField.text = [self.timeFormatter stringFromDate:picker.date];
}

- (void)countdownPickerChanged:(UIDatePicker *)picker
{
    self.countdownSelectionTextField.text = [NSString stringWithFormat:@"%f", picker.countDownDuration];
}

- (void)dateCalendarPickerChanged:(UIDatePicker *)picker
{
    self.datePickerCalendarTextField.text = [self.dateFormatter stringFromDate:picker.date];
}

- (void)dateTimeCalendarPickerChanged:(UIDatePicker *)picker
{
    self.dateTimePickerCalendarTextField.text = [self.dateFormatter stringFromDate:picker.date];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 14;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [ @[@"Alpha", @"Bravo", @"Charlie", @"Delta", @"Echo", @"Foxtrot", @"Golf", @"Hotel", @"India", @"Juliet", @"Kilo", @"Lima", @"Mike", @"N8117U"] objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView accessibilityLabelForComponent:(NSInteger)component
{
    return @"Call Sign";
}

@end
