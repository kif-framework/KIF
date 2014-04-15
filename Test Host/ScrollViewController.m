//
//  ScrollViewController.m
//  KIF
//
//  Created by Hilton Campbell on 2/20/14.
//
//

#import <UIKit/UIKit.h>

@interface ScrollViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(2000, 2000);
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomButton setTitle:@"Down" forState:UIControlStateNormal];
    bottomButton.backgroundColor = [UIColor greenColor];
    bottomButton.frame = CGRectMake(950, 1500, 100, 44);
    [self.scrollView addSubview:bottomButton];
    
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [upButton setTitle:@"Up" forState:UIControlStateNormal];
    upButton.backgroundColor = [UIColor greenColor];
    upButton.frame = CGRectMake(950, 500, 100, 44);
    [self.scrollView addSubview:upButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setTitle:@"Right" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor greenColor];
    rightButton.frame = CGRectMake(1500, 978, 100, 44);
    [self.scrollView addSubview:rightButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton setTitle:@"Left" forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor greenColor];
    leftButton.frame = CGRectMake(500, 978, 100, 44);
    [self.scrollView addSubview:leftButton];
}

@end
