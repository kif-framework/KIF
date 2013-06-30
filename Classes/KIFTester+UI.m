//
//  KIFTester+UI.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTester+UI.h"
#import "UIApplication-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "KIFTestStep.h"

@implementation KIFTester (UI)

- (void)run:(KIFTestStep *)step
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        return [step executeAndReturnError:error];
    } complete:nil timeout:step.timeout];
}

- (void)waitForViewWithAccessibilityLabel:(NSString *)label
{
    [self waitForViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

- (void)waitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self waitForViewWithAccessibilityLabel:label value:nil traits:traits];
}

- (void)waitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:value tappable:NO traits:traits error:error];
        
        NSString *waitDescription = nil;
        if (value.length) {
            waitDescription = [NSString stringWithFormat:@"Waiting for presence of accessibility element with label \"%@\" and accessibility value \"%@\"", label, value];
        } else {
            waitDescription = [NSString stringWithFormat:@"Waiting for presence of accessibility element with label \"%@\"", label];
        }
        
        KIFTestWaitCondition(element, error, @"%@", waitDescription);
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:label]];
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self run:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:label traits:traits]];
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [self run:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:label value:value traits:traits]];
}

- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:label]];
}

- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self run:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:label traits:traits]];
}

- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [self run:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:label value:value traits:traits]];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToTapViewWithAccessibilityLabel:label]];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self run:[KIFTestStep stepToTapViewWithAccessibilityLabel:label traits:traits]];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [self run:[KIFTestStep stepToTapViewWithAccessibilityLabel:label value:value traits:traits]];
}

- (void)tapScreenAtPoint:(CGPoint)screenPoint
{
    [self run:[KIFTestStep stepToTapScreenAtPoint:screenPoint]];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label duration:(NSTimeInterval)duration;
{
    [self run:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:label duration:duration]];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value duration:(NSTimeInterval)duration;
{
    [self run:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:label value:value duration:duration]];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits duration:(NSTimeInterval)duration;
{
    [self run:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:label value:value traits:traits duration:duration]];
}

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text;
{
    [self run:[KIFTestStep stepToEnterTextIntoCurrentFirstResponder:text]];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToEnterText:text intoViewWithAccessibilityLabel:label]];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult
{
    [self run:[KIFTestStep stepToEnterText:text intoViewWithAccessibilityLabel:label traits:traits expectedResult:expectedResult]];
}

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label
{
    [self clearTextFromViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self waitForViewWithAccessibilityLabel:label traits:traits];
    
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:traits];

    NSMutableString *text = [NSMutableString string];
    for (NSInteger i = 0; i < element.accessibilityValue.length; i ++) {
        [text appendString:@"\b"];
    }

    [self enterText:text intoViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone expectedResult:@""];
}

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    [self clearTextFromViewWithAccessibilityLabel:label];
    [self enterText:text intoViewWithAccessibilityLabel:label];
}

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult
{
    [self clearTextFromViewWithAccessibilityLabel:label traits:traits];
    [self enterText:text intoViewWithAccessibilityLabel:label traits:traits expectedResult:expectedResult];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title
{
    [self run:[KIFTestStep stepToSelectPickerViewRowWithTitle:title]];
}

- (void)setOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToSetOn:switchIsOn forSwitchWithAccessibilityLabel:label]];
}

- (void)dismissPopover
{
    [self run:[KIFTestStep stepToDismissPopover]];
}

- (void)choosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column
{
    for (KIFTestStep *step in [KIFTestStep stepsToChoosePhotoInAlbum:albumName atRow:row column:column]) {
        [self run:step];
    }
}

- (void)tapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath
{
    [self run:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:tableViewLabel atIndexPath:indexPath]];
}

- (void)swipeViewWithAccessibilityLabel:(NSString *)label inDirection:(KIFSwipeDirection)direction
{
    [self run:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:label inDirection:direction]];
}

#define NUM_POINTS_IN_SCROLL_PATH 5

- (void)scrollViewWithAccessibilityLabel:(NSString *)label byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:nil tappable:NO traits:UIAccessibilityTraitNone error:error];
        
        KIFTestWaitCondition(element, error, @"Cannot find accessibility element with accessibility label \"%@\"", label);
        
        UIView *viewToScroll = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(viewToScroll, error, @"Cannot find view with accessibility label \"%@\"", label);

        // Within this method, all geometry is done in the coordinate system of
        // the view to scroll.
        
        CGRect elementFrame = [viewToScroll.window convertRect:element.accessibilityFrame toView:viewToScroll];
        
        CGSize scrollDisplacement = CGSizeMake(elementFrame.size.width * horizontalFraction, elementFrame.size.height * verticalFraction);
        
        CGPoint scrollStart = CGPointCenteredInRect(elementFrame);
        scrollStart.x -= scrollDisplacement.width / 2;
        scrollStart.y -= scrollDisplacement.height / 2;
        
        CGPoint scrollPath[NUM_POINTS_IN_SCROLL_PATH];
        
        for (int pointIndex = 0; pointIndex < NUM_POINTS_IN_SCROLL_PATH; pointIndex++)
        {
            CGFloat scrollProgress = ((CGFloat)pointIndex)/(NUM_POINTS_IN_SCROLL_PATH - 1);
            scrollPath[pointIndex] = CGPointMake(scrollStart.x + (scrollProgress * scrollDisplacement.width),
                                                 scrollStart.y + (scrollProgress * scrollDisplacement.height));
        }
        
        [viewToScroll dragAlongPathWithPoints:scrollPath count:NUM_POINTS_IN_SCROLL_PATH];
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForFirstResponderWithAccessibilityLabel:(NSString *)label
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIResponder *firstResponder = [[[UIApplication sharedApplication] keyWindow] firstResponder];
        KIFTestWaitCondition([[firstResponder accessibilityLabel] isEqualToString:label], error, @"Expected accessibility label for first responder to be '%@', got '%@'", label, [firstResponder accessibilityLabel]);
        
        return KIFTestStepResultSuccess;
    }];
}

@end

