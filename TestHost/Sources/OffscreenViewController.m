//
//  OffscreenViewController.m
//  TestHost
//
//  Created by Steve Sun on 2023-03-28.
//

@interface OffscreenViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) UIView *alphaView;
@property (strong, nonatomic) UIView *movingView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *hiddenView;

@property (strong, nonatomic) UIView *scrollMovingView;
@end

@implementation OffscreenViewController

// Creates one of the plain colored boxes that OffscreenTests looks for by label.
static UIView *OffscreenBox(CGRect frame, UIViewAutoresizing autoresizingMask, UIColor *color, NSString *accessibilityLabel)
{
    UIView *box = [[UIView alloc] initWithFrame:frame];
    box.autoresizingMask = autoresizingMask;
    box.backgroundColor = color;
    box.isAccessibilityElement = YES;
    box.accessibilityLabel = accessibilityLabel;
    return box;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor systemBackgroundColor];

    self.movingView = OffscreenBox(CGRectMake(20, 121, 237, 129),
                                   UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin,
                                   [UIColor labelColor],
                                   @"Out of screen view");
    [view addSubview:self.movingView];

    self.alphaView = OffscreenBox(CGRectMake(20, 281, 240, 128),
                                  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin,
                                  [UIColor systemBrownColor],
                                  @"Alpha view");
    [view addSubview:self.alphaView];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 467, 237, 127)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.scrollView.multipleTouchEnabled = YES;
    self.scrollView.clipsToBounds = YES;
    [view addSubview:self.scrollView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 36, 183, 36);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
        configuration.title = @"Move and hide views";
        button.configuration = configuration;
    } else {
        [button setTitle:@"Move and hide views" forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(hideAndMoveViewsTapped:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    self.hiddenView = OffscreenBox(CGRectMake(268, 231, 76, 128),
                                   UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin,
                                   [UIColor systemPurpleColor],
                                   @"Hidden view");
    [view addSubview:self.hiddenView];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.accessibilityLabel = @"Scroll View";
    self.scrollView.contentInset = UIEdgeInsetsMake(2000, 2000, 0, 0);
    self.scrollView.contentSize = CGSizeMake(2000, 2000);
    self.scrollView.delegate = self;

    self.scrollMovingView = [UIView new];
    self.scrollMovingView.frame = CGRectMake(1000, 500, 100, 100);
    self.scrollMovingView.backgroundColor = [UIColor systemPinkColor];
    self.scrollMovingView.accessibilityLabel = @"Scroll moving view";

    [self.scrollView addSubview:self.scrollMovingView];
}

- (void)hideAndMoveViewsTapped:(UIButton *)sender
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.movingView.frame = CGRectMake(screenRect.size.width + 10,
                                           self.movingView.frame.origin.y,
                                           self.movingView.frame.size.width,
                                           self.movingView.frame.size.height);
        self.scrollMovingView.frame = CGRectMake(50000,
                                                 self.scrollMovingView.frame.origin.y,
                                                 self.scrollMovingView.frame.size.width,
                                                 self.scrollMovingView.frame.size.height);
        self.alphaView.alpha = 0;
        [self.hiddenView setHidden:YES];
    } completion:^(BOOL finished) {}];

}

#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView;
}

@end
