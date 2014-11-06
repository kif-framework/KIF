//
//  KIFUITestActor+IdentifierTests.m
//  KIF
//
//  Created by Brian Nickel on 11/6/14.
//
//

#import "KIFUITestActor-IdentifierTests.h"
#import "UIAccessibilityElement-KIFAdditions.h"

@implementation KIFUITestActor (IdentifierTests)

- (UIView *)waitForViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    return [self waitForViewWithAccessibilityIdentifier:accessibilityIdentifier tappable:NO];
}

- (UIView *)waitForTappableViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    return [self waitForViewWithAccessibilityIdentifier:accessibilityIdentifier tappable:YES];
}

- (void)tapViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    @autoreleasepool {
        UIView *view = nil;
        UIAccessibilityElement *element = nil;
        [self waitForAccessibilityElement:&element view:&view withIdentifier:accessibilityIdentifier tappable:YES];
        [self tapAccessibilityElement:element inView:view];
    }
}

- (void)waitForAbsenceOfViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // If the app is ignoring interaction events, then wait before doing our analysis
        KIFTestWaitCondition(![[UIApplication sharedApplication] isIgnoringInteractionEvents], error, @"Application is ignoring interaction events.");
        
        // If the element can't be found, then we're done
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@", accessibilityIdentifier];
        UIAccessibilityElement *element = nil;
        
        if (![UIAccessibilityElement accessibilityElement:&element view:NULL withElementMatchingPredicate:predicate tappable:NO error:NULL]) {
            return KIFTestStepResultSuccess;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        
        // If we found an element, but it's not associated with a view, then something's wrong. Wait it out and try again.
        KIFTestWaitCondition(view, error, @"Cannot find view containing accessibility element with the identifier \"%@\"", accessibilityIdentifier);
        
        // Hidden views count as absent
        KIFTestWaitCondition([view isHidden] || [view superview] == nil, error, @"Accessibility element with identifier \"%@\" is visible and not hidden.", accessibilityIdentifier);
        
        return KIFTestStepResultSuccess;
    }];
}

- (UIView *)waitForViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier tappable:(BOOL)mustBeTappable
{
    UIView *view = nil;
    @autoreleasepool {
        [self waitForAccessibilityElement:NULL view:&view withIdentifier:accessibilityIdentifier tappable:mustBeTappable];
    }
    
    return view;
}

@end
