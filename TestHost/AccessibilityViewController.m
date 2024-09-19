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

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *swtichLabel;
@property (nonatomic, strong) UISwitch *activationSwitch;

@end


@implementation AccessibilityViewController_AccessibilityView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    self.isAccessibilityElement = YES;
    self.accessibilityLabel = @"AccessibilityView";
        
    self.activationReturnValue = YES;
    
    self.topLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.topLabel.text = @"Awaiting activation or tap";
    [self addSubview:self.topLabel];

    self.swtichLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.swtichLabel.text = @"Returns YES";
    [self addSubview:self.swtichLabel];
    
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
        self.swtichLabel.text = @"Returns YES";
    } else {
        self.backgroundColor = [UIColor systemTealColor];
        self.swtichLabel.text = @"Returns NO";
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.topLabel sizeToFit];
    self.topLabel.frame = CGRectMake(20,
                                     20,
                                     self.topLabel.frame.size.width,
                                     self.topLabel.frame.size.height);
    
    [self.swtichLabel sizeToFit];
    self.swtichLabel.frame = CGRectMake(20,
                                        CGRectGetMaxY(self.topLabel.frame) + 40,
                                        self.swtichLabel.frame.size.width,
                                        self.swtichLabel.frame.size.height);
    
    [self.activationSwitch sizeToFit];
    self.activationSwitch.frame = CGRectMake(20,
                                             CGRectGetMaxY(self.swtichLabel.frame) + 10 ,
                                             self.activationSwitch.frame.size.width,
                                             self.activationSwitch.frame.size.width);
    
}

- (NSString *)accessibilityValue {
   return self.topLabel.text;
}

- (BOOL)accessibilityActivate {
    self.activationCount += 1;
    self.topLabel.text = [NSString stringWithFormat:@"Activated: %i", self.activationCount];
    [self setNeedsLayout];
    return self.activationReturnValue;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView: self];
    self.topLabel.text =  [NSString stringWithFormat:@"Tapped - x:%.04f, y:%.04f", location.x, location.y];
    [self setNeedsLayout];
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
