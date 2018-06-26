//
//  KIFTester+UI.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFUITestActor.h"

#import "CALayer-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "KIFEnumDefines.h"
#import "KIFSystemTestActor.h"
#import "KIFTestActor_Private.h"
#import "KIFTypist.h"
#import "KIFUIObject.h"
#import "KIFUIViewTestActor_Private.h"
#import "NSError-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIAutomationHelper.h"
#import "UIScreen+KIFAdditions.h"
#import "UITableView-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"


//#if DEPRECATE_KIF_TESTER
//KIFUITestActor *_KIF_tester()
//{
//    NSCAssert(NO, @"Attempting to use deprecated `KIFUITestActor`!");
//    return nil;
//}
//#endif


@implementation KIFUITestActor

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label
{
    return [[self usingLabel:label] waitForView];
}

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    
    return [[[self usingLabel:label] usingTraits:traits] waitForView];
}

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    return [[[[self usingLabel:label] usingValue:value] usingTraits:traits] waitForView];
}

- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label
{
    return [[self usingLabel:label] waitForTappableView];
}

- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    return [[[self usingLabel:label] usingTraits:traits] waitForTappableView];
}

- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    return [[[[self usingLabel:label] usingValue:value] usingTraits:traits] waitForTappableView];
}

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable
{
    if (mustBeTappable) {
        return [self waitForTappableViewWithAccessibilityLabel:label value:value traits:traits];
    }
    
    return  [self waitForViewWithAccessibilityLabel:label value:value traits:traits];
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement **)element view:(out UIView **)view withIdentifier:(NSString *)identifier tappable:(BOOL)mustBeTappable
{
    KIFUIObject *found = [[self usingIdentifier:identifier] predicateSearchWithRequiresMatch:NO mustBeTappable:mustBeTappable];
    if (element != NULL) {
        *element = found.element;
    }
    if (view != NULL) {
        *view =  found.view;
    }
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement *__autoreleasing *)element view:(out UIView *__autoreleasing *)view withIdentifier:(NSString *)identifier fromRootView:(UIView *)fromView tappable:(BOOL)mustBeTappable
{
    
//    [self runBlock:^KIFTestStepResult(NSError **error) {
//        return [UIAccessibilityElement accessibilityElement:element view:view withElementMatchingPredicate:[NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@", identifier] fromRootView:fromView tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
//    }];
}
- (void)waitForAccessibilityElement:(UIAccessibilityElement *__autoreleasing *)element view:(out UIView *__autoreleasing *)view withLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable;
{
    KIFUIObject *found = [[[[self usingLabel:label] usingValue:value] usingTraits:traits] predicateSearchWithRequiresMatch:NO mustBeTappable:mustBeTappable];
    *element =  found.element;
    *view =  found.view;
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] waitForAbsenceOfView];
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [[[self usingLabel:label] usingTraits:traits] waitForAbsenceOfView];
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [[[[self usingLabel:label] usingValue:value] usingTraits:traits] waitForAbsenceOfView];
}

- (void)waitForAbsenceOfViewWithElementMatchingPredicate:(NSPredicate *)predicate {
    [[self usingPredicate:predicate] waitForAbsenceOfView];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] tap];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [[[self usingLabel:label] usingTraits:traits] tap];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [[[[self usingLabel:label] usingValue:value] usingTraits:traits] tap];
}

- (void)tapAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)view;
{
    [super tapAccessibilityElement:element inView:view];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label duration:(NSTimeInterval)duration;
{
    [[self usingLabel:label] longPressWithDuration:duration];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value duration:(NSTimeInterval)duration;
{
    [[[self usingLabel: label] usingValue:value] longPressWithDuration:duration];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits duration:(NSTimeInterval)duration;
{
    [[[[self usingLabel:label] usingValue:value] usingTraits:traits] longPressWithDuration:duration];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] enterText:text];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult
{
    [[[self usingLabel: label] usingTraits:traits] enterText:text expectedResult:expectedResult];
}

- (void)expectView:(UIView *)view toContainText:(NSString *)text;
{
    ///
}

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] clearText];
}

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [[[self usingLabel:label] usingTraits:traits] clearText];
}


- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] clearText];
    [[self usingLabel:label] enterText:text];
}

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult
{
    [[[self usingLabel:label] usingTraits:traits] clearText];
    [[[self usingLabel:label] usingTraits:traits] enterText:text expectedResult:expectedResult];
}


- (void)setText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] setText:text];
}

- (void)setOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label]setSwitchOn:switchIsOn];
}

- (void)setValue:(float)value forSliderWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] setSliderValue:value];
}

- (void)tapRowAtIndexPath:(NSIndexPath *)indexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier
{
    [[self usingIdentifier:identifier] tapRowInTableViewAtIndexPath:indexPath];
}

- (void)tapRowInTableViewWithAccessibilityLabel:(NSString *)tableViewLabel atIndexPath:(NSIndexPath *)indexPath
{
    [[self usingLabel:tableViewLabel] tapRowInTableViewAtIndexPath:indexPath];
}

- (void)swipeRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView inDirection:(KIFSwipeDirection)direction;
{
    [super swipeRowAtIndexPath:indexPath inTableView:tableView inDirection:direction];
}

- (void)tapItemAtIndexPath:(NSIndexPath *)indexPath inCollectionViewWithAccessibilityIdentifier:(NSString *)identifier
{
    [[self usingIdentifier:identifier] tapCollectionViewItemAtIndexPath:indexPath];
}

- (void)swipeViewWithAccessibilityLabel:(NSString *)label inDirection:(KIFSwipeDirection)direction
{
    [[self usingLabel:label] swipeInDirection:direction];
}

- (void)swipeViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value inDirection:(KIFSwipeDirection)direction
{
    [[[self usingLabel:label] usingValue:value] swipeInDirection:direction];
}

- (void)swipeViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits inDirection:(KIFSwipeDirection)direction
{
    [[[[self usingLabel:label] usingValue:value] usingTraits:traits] swipeInDirection:direction];
}

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] pullToRefresh];
}

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label pullDownDuration:(KIFPullToRefreshTiming) pullDownDuration
{
    [[self usingLabel:label] pullToRefreshWithDuration:pullDownDuration];
}

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value
{
    [[[self usingLabel:label] usingValue:value] pullToRefresh];
}

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value pullDownDuration:(KIFPullToRefreshTiming) pullDownDuration traits:(UIAccessibilityTraits)traits
{
    [[[[self usingLabel:label] usingValue:value] usingTraits:traits] pullToRefreshWithDuration:pullDownDuration];
}

- (void)scrollViewWithAccessibilityLabel:(NSString *)label byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction
{
    [[self usingLabel:label] scrollByFractionOfSizeHorizontal:horizontalFraction vertical:verticalFraction];
}

- (void)scrollViewWithAccessibilityIdentifier:(NSString *)identifier byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction
{
    [[self usingIdentifier:identifier] scrollByFractionOfSizeHorizontal:horizontalFraction vertical:verticalFraction];
}

- (void)waitForFirstResponderWithAccessibilityLabel:(NSString *)label
{
    [[self usingLabel:label] waitToBecomeFirstResponder];
}

- (void)waitForFirstResponderWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [[[self usingLabel:label] usingTraits:traits] waitToBecomeFirstResponder];
}

- (UITableViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier
{
   return [[self usingIdentifier:identifier] waitForCellInTableViewAtIndexPath:indexPath];
}

- (UITableViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier atPosition:(UITableViewScrollPosition)position
{
    return [[self usingIdentifier:identifier] waitForCellInTableViewAtIndexPath:indexPath atPosition:position];
}

- (UICollectionViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inCollectionViewWithAccessibilityIdentifier:(NSString *)identifier
{
    return [[self usingIdentifier:identifier] waitForCellInCollectionViewAtIndexPath:indexPath];
}

- (void)waitForDeleteStateForCellAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*)tableView;
{
    [super waitForDeleteStateForCellAtIndexPath:indexPath inTableView:tableView];
}
- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier
{
    [[self usingIdentifier:identifier] moveRowInTableViewAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

-(void) tapStepperWithAccessibilityLabel: (NSString *)accessibilityLabel increment: (KIFStepperDirection) stepperDirection
{
    [[self usingLabel:accessibilityLabel] tapStepperToIncrement:stepperDirection];
}

@end
