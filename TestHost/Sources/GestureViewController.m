//
//  GestureViewController.m
//  KIF
//
//  Created by Brian Nickel on 7/28/13.
//
//

#import <UIKit/UIKit.h>

@interface GestureViewController : UIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UILabel *lastSwipeDescriptionLabel;
@property (strong, nonatomic) UILabel *lastVelocityVeluesLabel;
@property (strong, nonatomic) UILabel *bottomRightLabel;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *panAreaLabel;

@end

@implementation GestureViewController

// Every view on this screen is positioned by constraints. The frames given here are only the
// design-time starting values, which viewDidLoad relies on to size the scroll view's content.
// Labels accept touches so KIF's hit testing can find them; the two status labels opt out.
- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    label.userInteractionEnabled = YES;
    label.opaque = NO;
    label.backgroundColor = nil;
    label.contentMode = UIViewContentModeLeft;
    label.text = text;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor labelColor];
    label.textAlignment = NSTextAlignmentLeft;
    [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    return label;
}

// The swipe and pan targets are red bands with near-white text.
- (UILabel *)gestureAreaLabelWithFrame:(CGRect)frame text:(NSString *)text identifier:(NSString *)identifier
{
    UILabel *label = [self labelWithFrame:frame text:text];
    label.backgroundColor = [UIColor colorWithRed:0.98594832420349121 green:0 blue:0.026950567960739136 alpha:1];
    label.textColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.accessibilityIdentifier = identifier;
    return label;
}

- (void)addSwipeGestureRecognizerToView:(UIView *)view direction:(UISwipeGestureRecognizerDirection)direction action:(SEL)action
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:action];
    swipe.direction = direction;
    [view addGestureRecognizer:swipe];
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    view.backgroundColor = [UIColor colorWithRed:1 green:0.99997437000274658 blue:0.99999129772186279 alpha:1];

    self.panAreaLabel = [self gestureAreaLabelWithFrame:CGRectMake(0, 200, 414, 100) text:@"Pan Me" identifier:@"gestures.panMe"];
    [self.panAreaLabel addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hadlePanGestureRecognizer:)]];
    [view addSubview:self.panAreaLabel];

    self.lastVelocityVeluesLabel = [self labelWithFrame:CGRectMake(0, 150, 414, 50) text:@"Label"];
    self.lastVelocityVeluesLabel.userInteractionEnabled = NO;
    self.lastVelocityVeluesLabel.textColor = [UIColor darkTextColor];
    self.lastVelocityVeluesLabel.textAlignment = NSTextAlignmentCenter;
    self.lastVelocityVeluesLabel.accessibilityLabel = @"velocityValueLabel";
    [view addSubview:self.lastVelocityVeluesLabel];

    UILabel *swipeAreaLabel = [self gestureAreaLabelWithFrame:CGRectMake(0, 50, 414, 100) text:@"Swipe Me" identifier:@"gestures.swipeMe"];
    [self addSwipeGestureRecognizerToView:swipeAreaLabel direction:UISwipeGestureRecognizerDirectionUp action:@selector(swipedUp:)];
    [self addSwipeGestureRecognizerToView:swipeAreaLabel direction:UISwipeGestureRecognizerDirectionDown action:@selector(swipedDown:)];
    [self addSwipeGestureRecognizerToView:swipeAreaLabel direction:UISwipeGestureRecognizerDirectionLeft action:@selector(swipedLeft:)];
    [self addSwipeGestureRecognizerToView:swipeAreaLabel direction:UISwipeGestureRecognizerDirectionRight action:@selector(swipedRight:)];
    [view addSubview:swipeAreaLabel];

    self.lastSwipeDescriptionLabel = [self labelWithFrame:CGRectMake(0, 0, 414, 50) text:@"Label"];
    self.lastSwipeDescriptionLabel.userInteractionEnabled = NO;
    self.lastSwipeDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.lastSwipeDescriptionLabel];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, 414, 421)];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.scrollView.multipleTouchEnabled = YES;
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.13529640436172485 green:1 blue:0.024918794631958008 alpha:1];
    self.scrollView.accessibilityIdentifier = @"Scroll View";
    [view addSubview:self.scrollView];

    // Pinned to all four edges of the scroll view, this sets the scrollable area to 500x500.
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.scrollView addSubview:contentView];

    UILabel *topLeftLabel = [self labelWithFrame:CGRectMake(0, 0, 62, 20) text:@"Top Left"];
    [self.scrollView addSubview:topLeftLabel];

    self.bottomRightLabel = [self labelWithFrame:CGRectMake(400, 480, 100, 20) text:@"Bottom Right"];
    [self.scrollView addSubview:self.bottomRightLabel];

    for (NSNumber *edge in @[@(UIRectEdgeLeft), @(UIRectEdgeRight)]) {
        UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenEdgePanGestureRecognizer:)];
        edgePan.edges = edge.unsignedIntegerValue;
        // Edge pans default to a single touch. Allow as many as a plain pan does.
        edgePan.maximumNumberOfTouches = UINT_MAX;
        // As the delegate, this controller makes the other recognizers wait for edge pans to fail.
        edgePan.delegate = self;
        [view addGestureRecognizer:edgePan];
    }

    UILayoutGuide *safeArea = view.safeAreaLayoutGuide;
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray arrayWithArray:@[
        [self.lastSwipeDescriptionLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
        [self.lastSwipeDescriptionLabel.heightAnchor constraintEqualToConstant:50],
        [swipeAreaLabel.topAnchor constraintEqualToAnchor:self.lastSwipeDescriptionLabel.bottomAnchor],
        [swipeAreaLabel.heightAnchor constraintEqualToConstant:100],
        [self.lastVelocityVeluesLabel.topAnchor constraintEqualToAnchor:swipeAreaLabel.bottomAnchor],
        [self.lastVelocityVeluesLabel.heightAnchor constraintEqualToConstant:50],
        [self.panAreaLabel.topAnchor constraintEqualToAnchor:self.lastVelocityVeluesLabel.bottomAnchor],
        [self.panAreaLabel.heightAnchor constraintEqualToConstant:100],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.panAreaLabel.bottomAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor],

        [contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [contentView.widthAnchor constraintEqualToConstant:500],
        [contentView.heightAnchor constraintEqualToConstant:500],
        [topLeftLabel.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [topLeftLabel.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.bottomRightLabel.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.bottomRightLabel.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
    ]];
    for (UIView *row in @[self.lastSwipeDescriptionLabel, swipeAreaLabel, self.lastVelocityVeluesLabel, self.panAreaLabel, self.scrollView]) {
        [constraints addObject:[row.leadingAnchor constraintEqualToAnchor:view.leadingAnchor]];
        [constraints addObject:[row.trailingAnchor constraintEqualToAnchor:view.trailingAnchor]];
    }
    [NSLayoutConstraint activateConstraints:constraints];

    self.view = view;
}

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

- (void)swipedUp:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Up";
}

- (void)swipedDown:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Down";
}

- (void)swipedLeft:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Left";
}

- (void)swipedRight:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Right";
}

- (void)hadlePanGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    self.lastVelocityVeluesLabel.text = [self formattedVelocityValues:[sender velocityInView:self.panAreaLabel]];
}

- (void)handleScreenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)sender
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
