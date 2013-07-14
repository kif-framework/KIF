//
//  KIFTester+UI.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFUITestActor.h"
#import "UIApplication-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "KIFTypist.h"

@implementation KIFUITestActor

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
    [self waitForAbsenceOfViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self waitForAbsenceOfViewWithAccessibilityLabel:label value:nil traits:traits];
}

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // If the app is ignoring interaction events, then wait before doing our analysis
        KIFTestWaitCondition(![[UIApplication sharedApplication] isIgnoringInteractionEvents], error, @"Application is ignoring interaction events.");
        
        // If the element can't be found, then we're done
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:value traits:traits];
        if (!element) {
            return KIFTestStepResultSuccess;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        
        // If we found an element, but it's not associated with a view, then something's wrong. Wait it out and try again.
        KIFTestWaitCondition(view, error, @"Cannot find view containing accessibility element with the label \"%@\"", label);
        
        // Hidden views count as absent
        KIFTestWaitCondition([view isHidden], error, @"Accessibility element with label \"%@\" is visible and not hidden.", label);
        
        return KIFTestStepResultSuccess;
    }];}

- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label
{
    [self waitForTappableViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self waitForTappableViewWithAccessibilityLabel:label value:nil traits:traits];
}

- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:value tappable:YES traits:traits error:error];
        return (element ? KIFTestStepResultSuccess : KIFTestStepResultWait);
    }];}

- (void)tapViewWithAccessibilityLabel:(NSString *)label
{
    [self tapViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self tapViewWithAccessibilityLabel:label value:nil traits:traits];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    // After tapping the view we want to wait a short period to allow things to settle (animations and such). We can't do this using CFRunLoopRunInMode() because certain things, such as the built-in media picker, do things with the run loop that are not compatible with this kind of wait. Instead we leverage the way KIF hooks into the existing run loop by returning "wait" results for the desired period.
    const NSTimeInterval quiesceWaitInterval = 0.5;
    __block NSTimeInterval quiesceStartTime = 0.0;
    
    __block UIView *view = nil;
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        // If we've already tapped the view and stored it to a variable, and we've waited for the quiesce time to elapse, then we're done.
        if (view) {
            KIFTestWaitCondition(([NSDate timeIntervalSinceReferenceDate] - quiesceStartTime) >= quiesceWaitInterval, error, @"Waiting for view to become the first responder.");
            return KIFTestStepResultSuccess;
        }
        
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:value tappable:YES traits:traits error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Failed to find view for accessibility element with label \"%@\"", label);
        
        if (![view isUserInteractionActuallyEnabled]) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"View with accessibility label \"%@\" is not enabled for interaction", label]}] autorelease];
            }
            return KIFTestStepResultWait;
        }
        
        // If the accessibilityFrame is not set, fallback to the view frame.
        CGRect elementFrame;
        if (CGRectEqualToRect(CGRectZero, element.accessibilityFrame)) {
            elementFrame.origin = CGPointZero;
            elementFrame.size = view.frame.size;
        } else {
            elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        }
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestWaitCondition(!isnan(tappablePointInElement.x), error, @"The element with accessibility label %@ is not tappable", label);
        [view tapAtPoint:tappablePointInElement];
        
        KIFTestCondition(![view canBecomeFirstResponder] || [view isDescendantOfFirstResponder], error, @"Failed to make the view %@ which contains the accessibility element \"%@\" into the first responder", view, label);
        
        quiesceStartTime = [NSDate timeIntervalSinceReferenceDate];
        
        KIFTestWaitCondition(NO, error, @"Waiting for the view to settle.");
    }];
}

- (void)tapScreenAtPoint:(CGPoint)screenPoint
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        // Try all the windows until we get one back that actually has something in it at the given point
        UIView *view = nil;
        for (UIWindow *window in [[[UIApplication sharedApplication] windowsWithKeyWindow] reverseObjectEnumerator]) {
            CGPoint windowPoint = [window convertPoint:screenPoint fromView:nil];
            view = [window hitTest:windowPoint withEvent:nil];
            
            // If we hit the window itself, then skip it.
            if (view == window || view == nil) {
                continue;
            }
        }
        
        KIFTestWaitCondition(view, error, @"No view was found at the point %@", NSStringFromCGPoint(screenPoint));
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        CGPoint viewPoint = [view convertPoint:screenPoint fromView:nil];
        [view tapAtPoint:viewPoint];
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label duration:(NSTimeInterval)duration;
{
    [self longPressViewWithAccessibilityLabel:label value:nil duration:duration];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value duration:(NSTimeInterval)duration;
{
    [self longPressViewWithAccessibilityLabel:label value:value traits:UIAccessibilityTraitNone duration:duration];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits duration:(NSTimeInterval)duration;
{
    // After tapping the view we want to wait a short period to allow things to settle (animations and such). We can't do this using CFRunLoopRunInMode() because certain things, such as the built-in media picker, do things with the run loop that are not compatible with this kind of wait. Instead we leverage the way KIF hooks into the existing run loop by returning "wait" results for the desired period.
    const NSTimeInterval quiesceWaitInterval = 0.5;
    __block NSTimeInterval quiesceStartTime = 0.0;
    
    __block UIView *view = nil;
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        // If we've already tapped the view and stored it to a variable, and we've waited for the quiesce time to elapse, then we're done.
        if (view) {
            KIFTestWaitCondition(([NSDate timeIntervalSinceReferenceDate] - quiesceStartTime) >= quiesceWaitInterval, error, @"Waiting for view to become the first responder.");
            return KIFTestStepResultSuccess;
        }
        
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:value tappable:YES traits:traits error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Failed to find view for accessibility element with label \"%@\"", label);
        
        if (![view isUserInteractionActuallyEnabled]) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"View with accessibility label \"%@\" is not enabled for interaction", label]}] autorelease];
            }
            return KIFTestStepResultWait;
        }
        
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestWaitCondition(!isnan(tappablePointInElement.x), error, @"The element with accessibility label %@ is not tappable", label);
        [view longPressAtPoint:tappablePointInElement duration:duration];
        
        KIFTestCondition(![view canBecomeFirstResponder] || [view isDescendantOfFirstResponder], error, @"Failed to make the view %@ which contains the accessibility element \"%@\" into the first responder", view, label);
        
        quiesceStartTime = [NSDate timeIntervalSinceReferenceDate];
        
        KIFTestWaitCondition(NO, error, @"Waiting for the view to settle.");
    }];
}

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // Wait for the keyboard
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        
        for (NSUInteger characterIndex = 0; characterIndex < [text length]; characterIndex++) {
            NSString *characterString = [text substringWithRange:NSMakeRange(characterIndex, 1)];
            
            if (![KIFTypist enterCharacter:characterString]) {
                KIFTestCondition(NO, error, @"Failed to find key for character \"%@\"", characterString);
            }
        }
        return KIFTestStepResultSuccess;
    }];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    return [self enterText:text intoViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone expectedResult:nil];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIAccessibilityElement *element = [UIAccessibilityElement accessibilityElementWithLabel:label accessibilityValue:nil tappable:YES traits:traits error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Cannot find view with accessibility label \"%@\"", label);
        
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestCondition(!isnan(tappablePointInElement.x), error, @"The element with accessibility label %@ is not tappable", label);
        [view tapAtPoint:tappablePointInElement];
        
        KIFTestWaitCondition([view isDescendantOfFirstResponder], error, @"Failed to make the view with accessibility label \"%@\" the first responder. First responder is %@", label, [[[UIApplication sharedApplication] keyWindow] firstResponder]);
        
        // Wait for the keyboard
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        
        for (NSUInteger characterIndex = 0; characterIndex < [text length]; characterIndex++) {
            NSString *characterString = [text substringWithRange:NSMakeRange(characterIndex, 1)];
            
            if (![KIFTypist enterCharacter:characterString]) {
                // Attempt to cheat if we couldn't find the character
                if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
                    NSLog(@"KIF: Unable to find keyboard key for %@. Inserting manually.", characterString);
                    [(UITextField *)view setText:[[(UITextField *)view text] stringByAppendingString:characterString]];
                } else {
                    KIFTestCondition(NO, error, @"Failed to find key for character \"%@\"", characterString);
                }
            }
        }
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
        
        // This is probably a UITextField- or UITextView-ish view, so make sure it worked
        if ([view respondsToSelector:@selector(text)]) {
            // We trim \n and \r because they trigger the return key, so they won't show up in the final product on single-line inputs
            NSString *expected = [expectedResult ? expectedResult : text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSString *actual = [[view performSelector:@selector(text)] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            KIFTestCondition([actual isEqualToString:expected], error, @"Failed to get text \"%@\" in field; instead, it was \"%@\"", expected, actual);
        }
        
        return KIFTestStepResultSuccess;
    }];
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
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // Find the picker view
        UIPickerView *pickerView = [[[[UIApplication sharedApplication] pickerViewWindow] subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"] lastObject];
        KIFTestCondition(pickerView, error, @"No picker view is present");
        
        NSInteger componentCount = [pickerView.dataSource numberOfComponentsInPickerView:pickerView];
        KIFTestCondition(componentCount == 1, error, @"The picker view has multiple columns, which is not supported in testing.");
        
        for (NSInteger componentIndex = 0; componentIndex < componentCount; componentIndex++) {
            NSInteger rowCount = [pickerView.dataSource pickerView:pickerView numberOfRowsInComponent:componentIndex];
            for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
                NSString *rowTitle = nil;
                if ([pickerView.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                    rowTitle = [pickerView.delegate pickerView:pickerView titleForRow:rowIndex forComponent:componentIndex];
                } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
                    // This delegate inserts views directly, so try to figure out what the title is by looking for a label
                    UIView *rowView = [pickerView.delegate pickerView:pickerView viewForRow:rowIndex forComponent:componentIndex reusingView:nil];
                    NSArray *labels = [rowView subviewsWithClassNameOrSuperClassNamePrefix:@"UILabel"];
                    UILabel *label = (labels.count > 0 ? labels[0] : nil);
                    rowTitle = label.text;
                }
                
                if ([rowTitle isEqual:title]) {
                    [pickerView selectRow:rowIndex inComponent:componentIndex animated:YES];
                    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
                    
                    // Tap in the middle of the picker view to select the item
                    [pickerView tap];
                    
                    // The combination of selectRow:inComponent:animated: and tap does not consistently result in
                    // pickerView:didSelectRow:inComponent: being called on the delegate. We need to do it explicitly.
                    if ([pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
                        [pickerView.delegate pickerView:pickerView didSelectRow:rowIndex inComponent:componentIndex];
                    }
                    
                    return KIFTestStepResultSuccess;
                }
            }
        }
        
        KIFTestCondition(NO, error, @"Failed to find picker view value with title \"%@\"", title);
        return KIFTestStepResultFailure;
    }];
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
    [self runBlock:^KIFTestStepResult(NSError **error) {
        const NSTimeInterval tapDelay = 0.05;
        NSArray *windows = [[UIApplication sharedApplication] windowsWithKeyWindow];
        KIFTestCondition(windows.count, error, @"Failed to find any windows in the application");
        UIView *dimmingView = [[windows[0] subviewsWithClassNamePrefix:@"UIDimmingView"] lastObject];
        [dimmingView tapAtPoint:CGPointMake(50.0f, 50.0f)];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, tapDelay, false);
        return KIFTestStepResultSuccess;
    }];
}

- (void)choosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column
{
    [self tapViewWithAccessibilityLabel:@"Choose Photo"];
    
    // This is basically the same as the step to tap with an accessibility label except that the accessibility labels for the albums have the number of photos appended to the end, such as "My Photos (3)." This means that we have to do a prefix match rather than an exact match.
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        NSString *labelPrefix = [NSString stringWithFormat:@"%@,   (", albumName];
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementMatchingBlock:^(UIAccessibilityElement *element) {
            return [element.accessibilityLabel hasPrefix:labelPrefix];
        }];
        
        KIFTestWaitCondition(element, error, @"Failed to find photo album with name %@", albumName);
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Failed to find view for photo album with name %@", albumName);
        
        if (![view isUserInteractionActuallyEnabled]) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Album picker is not enabled for interaction"]}] autorelease];
            }
            return KIFTestStepResultWait;
        }
        
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
        
        [view tapAtPoint:tappablePointInElement];
        
        return KIFTestStepResultSuccess;
    }];
    
    // Wait for media picker view controller to be pushed.
    [self waitForTimeInterval:0.5];
    
    // Tap the desired photo in the grid
    // TODO: This currently only works for the first page of photos. It should scroll appropriately at some point.
    const CGFloat headerHeight = 64.0;
    const CGSize thumbnailSize = CGSizeMake(75.0, 75.0);
    const CGFloat thumbnailMargin = 5.0;
    CGPoint thumbnailCenter;
    thumbnailCenter.x = thumbnailMargin + (MAX(0, column - 1) * (thumbnailSize.width + thumbnailMargin)) + thumbnailSize.width / 2.0;
    thumbnailCenter.y = headerHeight + thumbnailMargin + (MAX(0, row - 1) * (thumbnailSize.height + thumbnailMargin)) + thumbnailSize.height / 2.0;
    [self tapScreenAtPoint:thumbnailCenter];

    // Dismiss the resize UI
    [self tapViewWithAccessibilityLabel:@"Choose"];
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

