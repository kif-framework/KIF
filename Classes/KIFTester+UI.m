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
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:nil tappable:YES traits:UIAccessibilityTraitNone error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        UISwitch *switchView = (UISwitch *)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(switchView, error, @"Cannot find switch with accessibility label \"%@\"", label);
        KIFTestWaitCondition([switchView isKindOfClass:[UISwitch class]], error, @"View with accessibility label \"%@\" is a %@, not a UISwitch", label, NSStringFromClass([switchView class]));
        
        // No need to switch it if it's already in the correct position
        BOOL current = switchView.on;
        if (current == switchIsOn) {
            return KIFTestStepResultSuccess;
        }
        
        CGRect elementFrame = [switchView.window convertRect:element.accessibilityFrame toView:switchView];
        CGPoint tappablePointInElement = [switchView tappablePointInRect:elementFrame];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestCondition(!isnan(tappablePointInElement.x), error, @"The element with accessibility label %@ is not tappable", label);
        [switchView tapAtPoint:tappablePointInElement];
        
        // This is a UISwitch, so make sure it worked
        if (switchIsOn != switchView.on) {
            NSLog(@"Faking turning switch %@ with accessibility label %@", switchIsOn ? @"ON" : @"OFF", label);
            [switchView setOn:switchIsOn animated:YES];
            [switchView sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
        // The switch animation takes a second to finish, and the action callback doesn't get called until it does.
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5f, false);
        
        KIFTestCondition(switchView.on == switchIsOn, error, @"Failed to toggle switch to \"%@\"; instead, it was \"%@\"", switchIsOn ? @"ON" : @"OFF", switchView.on ? @"ON" : @"OFF");
        
        return KIFTestStepResultSuccess;
    }];
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
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:tableViewLabel];
        KIFTestCondition(element, error, @"View with label %@ not found", tableViewLabel);
        UITableView *tableView = (UITableView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");
        
        KIFTestCondition(tableView, error, @"Table view with label %@ not found", tableViewLabel);
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            KIFTestCondition([indexPath section] < [tableView numberOfSections], error, @"Section %d is not found in '%@' table view", [indexPath section], tableViewLabel);
            KIFTestCondition([indexPath row] < [tableView numberOfRowsInSection:[indexPath section]], error, @"Row %d is not found in section %d of '%@' table view", [indexPath row], [indexPath section], tableViewLabel);
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            cell = [tableView cellForRowAtIndexPath:indexPath];
        }
        KIFTestCondition(cell, error, @"Table view cell at index path %@ not found", indexPath);
        
        CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
        [tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
        
        return KIFTestStepResultSuccess;
    }];
}

#define NUM_POINTS_IN_SWIPE_PATH 20

- (void)swipeViewWithAccessibilityLabel:(NSString *)label inDirection:(KIFSwipeDirection)direction
{
    // The original version of this came from http://groups.google.com/group/kif-framework/browse_thread/thread/df3f47eff9f5ac8c
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:nil tappable:NO traits:UIAccessibilityTraitNone error:error];
        UIView *viewToSwipe = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(viewToSwipe, error, @"Cannot find view with accessibility label \"%@\"", label);
        
        // Within this method, all geometry is done in the coordinate system of
        // the view to swipe.
        
        CGRect elementFrame = [viewToSwipe.window convertRect:element.accessibilityFrame toView:viewToSwipe];
        CGPoint swipeStart = CGPointCenteredInRect(elementFrame);
        
        KIFDisplacement swipeDisplacement = KIFDisplacementForSwipingInDirection(direction);
        
        CGPoint swipePath[NUM_POINTS_IN_SWIPE_PATH];
        
        for (int pointIndex = 0; pointIndex < NUM_POINTS_IN_SWIPE_PATH; pointIndex++)
        {
            CGFloat swipeProgress = ((CGFloat)pointIndex)/(NUM_POINTS_IN_SWIPE_PATH - 1);
            swipePath[pointIndex] = CGPointMake(swipeStart.x + (swipeProgress * swipeDisplacement.x),
                                                swipeStart.y + (swipeProgress * swipeDisplacement.y));
        }
        
        [viewToSwipe dragAlongPathWithPoints:swipePath count:NUM_POINTS_IN_SWIPE_PATH];
        
        return KIFTestStepResultSuccess;
    }];
}

#define NUM_POINTS_IN_SCROLL_PATH 5

- (void)scrollViewWithAccessibilityLabel:(NSString *)label byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:nil tappable:NO traits:UIAccessibilityTraitNone error:error];
        
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

