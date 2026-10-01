//
//  GestureViewController.m
//  KIF
//
//  Created by Brian Nickel on 7/28/13.
//
//

#import <UIKit/UIKit.h>

@interface GestureViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lastSwipeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastVelocityVeluesLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *panAreaLabel;

@end

@implementation GestureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGRectUnion(self.scrollView.bounds, self.bottomRightLabel.frame).size;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setNavigationPopGesturesEnabled:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self setNavigationPopGesturesEnabled:YES];
}

// This screen tests its own swipe recognizers, so the navigation controller must not claim
// those swipes for itself. iOS 26 added a second pop gesture that triggers anywhere in the
// content rather than just at the screen edge, which otherwise swallows every swipe to the
// right and pops back to the test suite list.
- (void)setNavigationPopGesturesEnabled:(BOOL)enabled
{
    self.navigationController.interactivePopGestureRecognizer.enabled = enabled;

#if __IPHONE_26_0
    if (@available(iOS 26.0, *)) {
        self.navigationController.interactiveContentPopGestureRecognizer.enabled = enabled;
    }
#endif
}

- (IBAction)swipedUp:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Up";
}

- (IBAction)swipedDown:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Down";
}

- (IBAction)swipedLeft:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Left";
}

- (IBAction)swipedRight:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Right";
}

- (IBAction)hadlePanGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    self.lastVelocityVeluesLabel.text = [self formattedVelocityValues:[sender velocityInView:self.panAreaLabel]];
}

- (IBAction)handleScreenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)sender
{
    self.lastSwipeDescriptionLabel.text = sender.edges == UIRectEdgeLeft ? @"LeftEdge" : @"RightEdge";
}

- (NSString*)formattedVelocityValues:(CGPoint)velocity
{
    return [NSString stringWithFormat:@"X:%.2f Y:%.2f", velocity.x, velocity.y];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class]) {
        return YES;
    }
    return NO;
}

@end
