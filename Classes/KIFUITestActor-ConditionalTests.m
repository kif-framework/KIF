//
//  KIFUITestActor-ConditionalTests.m
//  KIF
//
//  Created by Brian Nickel on 7/24/14.
//
//

#import "KIFUITestActor-ConditionalTests.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "NSError-KIFAdditions.h"

@implementation KIFUITestActor (ConditionalTests)

- (BOOL)tryFindingViewWithAccessibilityLabel:(NSString *)label error:(out NSError **)error
{
    return [self tryFindingViewWithAccessibilityLabel:label value:nil traits:UIAccessibilityTraitNone tappable:NO error:error];
}

- (BOOL)tryFindingViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits error:(out NSError **)error
{
    return [self tryFindingViewWithAccessibilityLabel:label value:nil traits:traits tappable:NO error:error];
}

- (BOOL)tryFindingViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits error:(out NSError **)error
{
    return [self tryFindingViewWithAccessibilityLabel:label value:value traits:traits tappable:NO error:error];
}

- (BOOL)tryFindingTappableViewWithAccessibilityLabel:(NSString *)label error:(out NSError **)error
{
    return [self tryFindingViewWithAccessibilityLabel:label value:nil traits:UIAccessibilityTraitNone tappable:YES error:error];
}

- (BOOL)tryFindingTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits error:(out NSError **)error
{
    return [self tryFindingViewWithAccessibilityLabel:label value:nil traits:traits tappable:YES error:error];
}

- (BOOL)tryFindingTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits error:(out NSError **)error
{
    return [self tryFindingViewWithAccessibilityLabel:label value:value traits:traits tappable:YES error:error];
}

- (BOOL)tryFindingViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable error:(out NSError **)error
{
    if (mustBeTappable) {
       return  [[[[self usingLabel:label] usingValue:value] usingTraits: traits] tryFindingTappableView];
    } else {
        return  [[[[self usingLabel:label] usingValue:value] usingTraits: traits] tryFindingView];
    }
}


- (BOOL)tryFindingAccessibilityElement:(out UIAccessibilityElement **)element view:(out UIView **)view withIdentifier:(NSString *)identifier tappable:(BOOL)mustBeTappable error:(out NSError **)error
{
    return NO;
//
//    if (![UIAccessibilityElement instancesRespondToSelector:@selector(accessibilityIdentifier)]) {
//        [self failWithError:[NSError KIFErrorWithFormat:@"Running test on platform that does not support accessibilityIdentifier"] stopTest:YES];
//    }
//
//    return [self tryFindingAccessibilityElement:element view:view withElementMatchingPredicate:[NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@", identifier] tappable:mustBeTappable error:error];
}


@end
