//
//  OffscreenViewController.m
//  TestHost
//
//  Created by Steve Sun on 2023-03-28.
//

@interface OffscreenViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UIView *movingView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;

@property (strong, nonatomic) UIView *scrollMovingView;
@end

@implementation OffscreenViewController

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

- (IBAction)hideAndMoveViewsTapped:(UIButton *)sender
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
