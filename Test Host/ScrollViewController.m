//
//  ScrollViewController.m
//  KIF
//
//  Created by Hilton Campbell on 2/20/14.
//
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *longScrollview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView.accessibilityLabel = @"Scroll View";
    self.scrollView.contentInset = UIEdgeInsetsMake(2000, 2000, 0, 0);
    self.scrollView.contentSize = CGSizeMake(2000, 2000);
    self.scrollView.delegate = self;
    
    self.longScrollview.accessibilityLabel = @"Long Scroll View";
    CGFloat longScrollViewHeight = CGRectGetHeight(self.longScrollview.bounds) * 2;
    self.longScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.longScrollview.bounds), longScrollViewHeight);
    self.longScrollview.backgroundColor = UIColor.redColor;
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = @"THIS IS THE TOP";
    topLabel.accessibilityLabel = @"Top Label";
    topLabel.textAlignment = UITextAlignmentCenter;
    [self.longScrollview addSubview:topLabel];
    topLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.longScrollview.bounds), 40);
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"THIS IS THE BOTTOM";
    bottomLabel.accessibilityLabel = @"Bottom Label";
    bottomLabel.textAlignment = UITextAlignmentCenter;
    [self.longScrollview addSubview:bottomLabel];
    bottomLabel.frame = CGRectMake(0, longScrollViewHeight - 40, CGRectGetWidth(self.longScrollview.bounds), 40);
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomButton setTitle:@"Down" forState:UIControlStateNormal];
    bottomButton.backgroundColor = [UIColor greenColor];
    bottomButton.frame = CGRectMake(1000, 1500, 100, 50);
    [self.scrollView addSubview:bottomButton];
    
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [upButton setTitle:@"Up" forState:UIControlStateNormal];
    upButton.backgroundColor = [UIColor greenColor];
    upButton.frame = CGRectMake(1000, 500, 100, 50);
    [self.scrollView addSubview:upButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setTitle:@"Right" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor greenColor];
    rightButton.frame = CGRectMake(1500, 1000, 100, 50);
    [self.scrollView addSubview:rightButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton setTitle:@"Left" forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor greenColor];
    leftButton.frame = CGRectMake(500, 1000, 100, 50);
    [self.scrollView addSubview:leftButton];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(1500, 1500, 100, 100)];
    textView.backgroundColor = [UIColor redColor];
    textView.accessibilityLabel = @"TextView";
    [self.scrollView addSubview:textView];
}

#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // do nothing
}


@end
