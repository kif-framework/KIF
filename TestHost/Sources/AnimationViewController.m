//
//  AnimationViewController.m
//  KIF
//
//  Created by Hendrik von Prince on 11.11.14.
//
//

#import <UIKit/UIKit.h>

@interface AnimationViewController : UIViewController
@property (strong, nonatomic) UILabel *testLabel;
@end

@implementation AnimationViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];

    self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(139, 76, 42, 21)];
    self.testLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.testLabel.contentMode = UIViewContentModeLeft;
    self.testLabel.text = @"Label";
    self.testLabel.font = [UIFont systemFontOfSize:17];
    self.testLabel.textColor = [UIColor darkTextColor];
    self.testLabel.hidden = YES;
    [view addSubview:self.testLabel];

    self.view = view;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // simulate a time-consuming calculation
    sleep(2);
    self.testLabel.hidden = NO;
}

@end
