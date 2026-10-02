//
//  BackgroundViewController.m
//  KIF
//
//  Created by Jordan Zucker on 5/18/15.
//
//

@interface BackgroundViewController : UIViewController
@property (nonatomic, strong) UILabel *label;
@end

@implementation BackgroundViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(139, 263, 42, 21)];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.label.contentMode = UIViewContentModeLeft;
    self.label.text = @"Label";
    self.label.font = [UIFont systemFontOfSize:17];
    self.label.textColor = [UIColor darkTextColor];
    [view addSubview:self.label];

    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    self.label.isAccessibilityElement = YES;
    self.label.text = @"Start";
    self.label.accessibilityLabel = self.label.text;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification {
    self.label.text = @"Back";
    self.label.accessibilityLabel = self.label.text;
}

@end
