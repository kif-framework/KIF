//
//  AccessibilityViewController.m
//  Test Host
//
//  Created by Alex Odawa on 17/09/2024.
//

#import <UIKit/UIKit.h>

@interface AccessibilityViewController_AccessibilityView : UIView
@property (nonatomic, assign) BOOL activationReturnValue;
@property (nonatomic, assign) int activationCount;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UISwitch *activationSwitch;


@end


@implementation AccessibilityViewController_AccessibilityView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = @"AccessibilityView";
    
    
    self.activationReturnValue = YES;

    self.label = [[UILabel alloc] initWithFrame: CGRectZero];
    [self addSubview:self.label];

    self.backgroundColor = [UIColor systemTealColor];
    self.label.text = @"Returns YES";
    
    
    self.activationSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
    [self addSubview: self.activationSwitch];

    [self.activationSwitch setOn:self.activationReturnValue];
    [self.activationSwitch addTarget: self action: @selector(toggleReturnValue) forControlEvents: UIControlEventValueChanged];
    self.activationSwitch.accessibilityLabel = @"AccessibilitySwitch";

    return self;
}

- (void)toggleReturnValue {
    self.activationReturnValue = !self.activationReturnValue;
    
    if (self.activationReturnValue == YES) {
        self.backgroundColor = [UIColor systemTealColor];
        self.label.text = @"Returns YES";
    } else {
        self.backgroundColor = [UIColor systemTealColor];
        self.label.text = @"Returns NO";
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.label sizeToFit];
    self.label.frame = CGRectMake((self.frame.size.width - self.label.frame.size.width) / 2,
                                  (self.frame.size.height - self.label.frame.size.height) / 2,
                                  self.label.frame.size.width,
                                  self.label.frame.size.height);
    
    [self.activationSwitch sizeToFit];
    self.activationSwitch.frame = CGRectMake((self.frame.size.width - self.activationSwitch.frame.size.width) / 2,
                                             CGRectGetMaxY(self.label.frame) + 10 ,
                                             self.activationSwitch.frame.size.width,
                                             self.activationSwitch.frame.size.width);
}

- (BOOL)accessibilityActivate {
    self.activationCount += 1;
    self.accessibilityValue = [NSString stringWithFormat:@"Activated: %i", self.activationCount];
    return self.activationReturnValue;
}

@end

@interface AccessibilityViewController : UIViewController
@property (weak, nonatomic) IBOutlet AccessibilityViewController_AccessibilityView *accessibilityView;

@end

@implementation AccessibilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.accessibilityView.accessibilityCustomActions = [self customActions];
}


- (NSArray *)customActions
{
    NSArray *actions = @[self.customActionWithoutArgument, self.customActionWithArgument, self.customActionThatFails];
    if (@available(iOS 13.0, *)) {
        return [actions arrayByAddingObject: self.customActionWithBlock];
    }
    return actions;
}

- (UIAccessibilityCustomAction *)customActionWithBlock
{
    if (@available(iOS 13.0, *)) {
        return [[UIAccessibilityCustomAction alloc] initWithName: @"Action With block handler"
                                                   actionHandler:^BOOL(UIAccessibilityCustomAction * _Nonnull customAction) {
            return YES;
        }];
    } else {
        return  nil;
    }
}

- (UIAccessibilityCustomAction *)customActionWithoutArgument
{
    return [[UIAccessibilityCustomAction alloc] initWithName:@"Action without argument" target:self selector:@selector(customActionHandlerWithoutArgument)];
}

- (UIAccessibilityCustomAction *)customActionWithArgument
{
    return [[UIAccessibilityCustomAction alloc] initWithName:@"Action with argument" target:self selector:@selector(customActionHandlerWithArgument:)];
}

- (UIAccessibilityCustomAction *)customActionThatFails
{
    return [[UIAccessibilityCustomAction alloc] initWithName:@"Action that fails" target:self selector:@selector(customActionThatFails)];
}

- (BOOL)customActionHandlerWithoutArgument
{
    return YES;
}

- (BOOL)customActionHandlerWithArgument:(UIAccessibilityCustomAction *)action
{
    return YES;
}

- (BOOL)customActionHandlerThatFails
{
    return NO;
}

@end
