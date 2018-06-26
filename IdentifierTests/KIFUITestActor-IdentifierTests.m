//
//  KIFUITestActor+IdentifierTests.m
//  KIF
//
//  Created by Brian Nickel on 11/6/14.
//
//

#import <UIKit/UIKit.h>
#import "KIFUITestActor-IdentifierTests.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "NSError-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"

@implementation KIFUITestActor (IdentifierTests)

- (UIView *)waitForViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    return [[self usingIdentifier:accessibilityIdentifier] waitForView];
}

- (UIView *)waitForTappableViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    return [[self usingIdentifier:accessibilityIdentifier] waitForTappableView];
}

- (void)tapViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier] tap];
}

- (void)waitForAbsenceOfViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier] waitForAbsenceOfView];
}

- (UIView *)waitForViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier tappable:(BOOL)mustBeTappable
{
    if (mustBeTappable) {
        return [[self usingIdentifier:accessibilityIdentifier] waitForTappableView];
    }
    return [[self usingIdentifier:accessibilityIdentifier] waitForView];;
}

- (void)longPressViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier duration:(NSTimeInterval)duration
{
    [[self usingIdentifier:accessibilityIdentifier] longPressWithDuration:duration];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier] enterText:text];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier expectedResult:(NSString *)expectedResult
{
    [[self usingIdentifier:accessibilityIdentifier] enterText:text expectedResult:expectedResult];
}

- (void)clearTextFromViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier] clearText];
}

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier] clearAndEnterText:text];
}

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier expectedResult:(NSString *)expectedResult
{
    [[self usingIdentifier:accessibilityIdentifier] clearAndEnterText:text expectedResult:expectedResult];
}

- (void)setText:(NSString *)text intoViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier] setText:text];
}

- (void)setOn:(BOOL)switchIsOn forSwitchWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    
    [[self usingIdentifier:accessibilityIdentifier] setSwitchOn:switchIsOn];
}

- (void)setValue:(float)value forSliderWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier]setSliderValue:value];
}

- (void)waitForFirstResponderWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [[self usingIdentifier:accessibilityIdentifier] waitToBecomeFirstResponder];
    }

- (BOOL) tryFindingViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    return [[self usingIdentifier:accessibilityIdentifier] tryFindingView];
}

- (void)swipeViewWithAccessibilityIdentifier:(NSString *)identifier inDirection:(KIFSwipeDirection)direction
{
    [[self usingIdentifier:identifier]swipeInDirection:direction];
}

- (void)pullToRefreshViewWithAccessibilityIdentifier:(NSString *)identifier
{
    [[self usingIdentifier:identifier] pullToRefresh];
}

- (void)pullToRefreshViewWithAccessibilityIdentifier:(NSString *)identifier pullDownDuration:(KIFPullToRefreshTiming)pullDownDuration
{
    [[self usingIdentifier:identifier] pullToRefreshWithDuration:pullDownDuration];
}

-(void) tapStepperWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier increment:(KIFStepperDirection)stepperDirection
{
    [[self usingIdentifier:accessibilityIdentifier] tapStepperToIncrement:stepperDirection];
}
@end
