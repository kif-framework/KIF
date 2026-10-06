//
//  ShowHideViewController.m
//  Test Suite
//
//  Created by Brian K Nickel on 6/26/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowHideViewController : UIViewController
@property (strong, nonatomic) UIButton *aButton;
@property (strong, nonatomic) UIButton *bButton;
@property (strong, nonatomic) UIView *obscuringView;
@property (strong, nonatomic) UILabel *contentLabel;
@end

@implementation ShowHideViewController

// Every button on this screen is a bold-system-font push that keeps its distance from the top and bottom edges.
- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:0.42467421293258667 green:0.42466151714324951 blue:0.42466866970062256 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)loadView
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    // The storyboard decoded this as a plain view with a UIScrollView class, so it never got the scroll view defaults.
    view.clipsToBounds = NO;
    view.multipleTouchEnabled = NO;
    view.bouncesZoom = NO;
    view.backgroundColor = [UIColor whiteColor];

    [view addSubview:[self buttonWithFrame:CGRectMake(20, 26, 133, 47)
                                     title:@"Cover/Uncover"
                                    action:@selector(coverUncoverClicked)]];

    self.aButton = [self buttonWithFrame:CGRectMake(71, 383, 30, 29) title:@"A" action:@selector(toggleSelection:)];
    self.aButton.accessibilityHint = @"A button for A";
    [view addSubview:self.aButton];

    self.bButton = [self buttonWithFrame:CGRectMake(71, 548, 30, 31) title:@"B" action:@selector(toggleSelection:)];
    self.bButton.accessibilityValue = @"BB";
    [view addSubview:self.bButton];

    self.obscuringView = [[UIView alloc] initWithFrame:CGRectMake(5, 509, 163, 149)];
    self.obscuringView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.obscuringView.backgroundColor = [UIColor colorWithRed:0.98594832420349121 green:0 blue:0.026950567960739136 alpha:0.74];
    [view addSubview:self.obscuringView];

    [view addSubview:[self buttonWithFrame:CGRectMake(20, 112, 165, 42)
                                     title:@"Delayed Show/Hide"
                                    action:@selector(delayedButtonClicked)]];

    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(239, 124, 61, 18)];
    self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.contentLabel.opaque = NO;
    self.contentLabel.backgroundColor = nil;
    self.contentLabel.contentMode = UIViewContentModeLeft;
    self.contentLabel.text = @"Content";
    self.contentLabel.font = [UIFont systemFontOfSize:17];
    self.contentLabel.textColor = [UIColor darkTextColor];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.accessibilityTraits = UIAccessibilityTraitStaticText | UIAccessibilityTraitUpdatesFrequently;
    self.contentLabel.accessibilityValue = @"Value";
    [view addSubview:self.contentLabel];

    [view addSubview:[self buttonWithFrame:CGRectMake(20, 199, 156, 42)
                                     title:@"Instant Show/Hide"
                                    action:@selector(instantButtonClicked)]];

    self.view = view;
}

- (void)coverUncoverClicked
{
    CGPoint aCenter = self.aButton.center;
    CGPoint bCenter = self.bButton.center;
    CGPoint center = self.obscuringView.center;
    
    [UIView animateWithDuration:2 animations:^{
        self.obscuringView.center = (ABS(center.y - aCenter.y) < ABS(center.y - bCenter.y)) ? bCenter : aCenter;
    }];
}

- (void)delayedButtonClicked
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.contentLabel.hidden = !self.contentLabel.hidden;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DelayedShowHide" object:[UIApplication sharedApplication]];
    });
}

- (void)instantButtonClicked
{
    self.contentLabel.hidden = !self.contentLabel.hidden;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InstantShowHide" object:[UIApplication sharedApplication]];
}

- (void)toggleSelection:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

@end
