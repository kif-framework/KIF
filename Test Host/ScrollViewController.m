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
@property (weak, nonatomic) IBOutlet UILabel *tooFarLabel;
@end

@implementation ScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGRectUnion(self.scrollView.bounds, self.tooFarLabel.frame).size;
}

@end
