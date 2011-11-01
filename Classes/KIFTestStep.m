//
//  KIFTestStep.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestStep.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIScrollView-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"


static NSTimeInterval KIFTestStepDefaultTimeout = 10.0;

@interface KIFTestStep ()

@property (nonatomic, copy) KIFTestStepExecutionBlock executionBlock;
@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, retain) id notificationObject;
@property BOOL notificationOccurred;
@property BOOL observingForNotification;

+ (BOOL)_isUserInteractionEnabledForView:(UIView *)view;

+ (BOOL)_enterCharacter:(NSString *)characterString;
+ (BOOL)_enterCharacter:(NSString *)characterString history:(NSMutableDictionary *)history;
+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;

+ (UIAccessibilityElement *)_accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value tappable:(BOOL)mustBeTappable traits:(UIAccessibilityTraits)traits error:(out NSError **)error;

@end


@implementation KIFTestStep

@synthesize description;
@synthesize executionBlock;
@synthesize notificationName;
@synthesize notificationObject;
@synthesize notificationOccurred;
@synthesize observingForNotification;
@synthesize timeout;

#pragma mark Class Methods

+ (NSTimeInterval)defaultTimeout;
{
    return KIFTestStepDefaultTimeout;
}

+ (void)setDefaultTimeout:(NSTimeInterval)newDefaultTimeout;
{
    KIFTestStepDefaultTimeout = newDefaultTimeout;
}

+ (id)stepWithDescription:(NSString *)description executionBlock:(KIFTestStepExecutionBlock)executionBlock;
{
    NSAssert(description.length, @"All steps must have a description");
    NSAssert(executionBlock, @"A custom step cannot be created with an execution block");
    
    KIFTestStep *step = [[self alloc] init];
    step.description = description;
    step.executionBlock = executionBlock;
    return [step autorelease];
}

+ (id)stepThatFails;
{
    return [self stepWithDescription:@"Always fails" executionBlock:^(KIFTestStep *step, NSError **error) {
        KIFTestCondition(NO, error, @"This test always fails");
    }];
}

+ (id)stepThatSucceeds;
{
    return [self stepWithDescription:@"Always succeeds" executionBlock:^(KIFTestStep *step, NSError **error) {
        return KIFTestStepResultSuccess;
    }];
}

+ (void)stepFailed;
{
    // Add a logging call here or set a breakpoint to debug failed KIFTestCondition calls
}

+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label;
{
    return [self stepToWaitForViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    return [self stepToWaitForViewWithAccessibilityLabel:label value:nil traits:traits];
}

+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
    NSString *description = nil;
    if (value.length) {
        description = [NSString stringWithFormat:@"Wait for view with accessibility label \"%@\" and accessibility value \"%@\"", label, value];
    } else {
        description = [NSString stringWithFormat:@"Wait for view with accessibility label \"%@\"", label];
    }
    
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:value tappable:NO traits:traits error:error];
        
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

+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label;
{
    return [self stepToWaitForAbsenceOfViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    return [self stepToWaitForAbsenceOfViewWithAccessibilityLabel:label value:nil traits:traits];
}

+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
    NSString *description = nil;
    if (value.length) {
        description = [NSString stringWithFormat:@"Wait for view with accessibility label \"%@\" and accessibility value \"%@\" to be gone", label, value];
    } else {
        description = [NSString stringWithFormat:@"Wait for view with accessibility label \"%@\" to be gone", label];
    }
    
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
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
    }];
}

+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label;
{
    return [self stepToWaitForTappableViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    return [self stepToWaitForTappableViewWithAccessibilityLabel:label value:nil traits:traits];
}

+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
    NSString *description = nil;
    if (value.length) {
        description = [NSString stringWithFormat:@"Wait for tappable view with accessibility label \"%@\" and accessibility value \"%@\"", label, value];
    } else {
        description = [NSString stringWithFormat:@"Wait for tappable view with accessibility label \"%@\"", label];
    }
    
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:value tappable:YES traits:traits error:error];
        return (element ? KIFTestStepResultSuccess : KIFTestStepResultWait);
    }];
}

+ (id)stepToWaitForTimeInterval:(NSTimeInterval)interval description:(NSString *)description;
{
    // In general, we should discourage use of a step like this. It's pragmatic to include it though.
    __block NSTimeInterval startTime = 0;
    KIFTestStep *step = [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        if (startTime == 0) {
            startTime = [NSDate timeIntervalSinceReferenceDate];
        }

        KIFTestWaitCondition((([NSDate timeIntervalSinceReferenceDate] - startTime) >= interval), error, @"Waiting for time interval to expire.");

        return KIFTestStepResultSuccess;
    }];
    
    // Make sure that the timeout is set so that it doesn't timeout prematurely.
    step.timeout = interval + 1.0;
    
    return step;
}

+ (id)stepToWaitForNotificationName:(NSString *)name object:(id)object;
{
    NSString *description = [NSString stringWithFormat:@"Wait for notification \"%@\"", name];
    
    KIFTestStep *step = [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {  
        if (!step.observingForNotification) {            
            step.notificationName = name;
            step.notificationObject = object; 
            step.observingForNotification = YES;
            [[NSNotificationCenter defaultCenter] addObserver:step selector:@selector(_onObservedNotification:) name:name object:object];
        }
        
        KIFTestWaitCondition(step.notificationOccurred, error, @"Waiting for notification \"%@\"", name);        
        return KIFTestStepResultSuccess;
    }];   
    return step;
}

+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label;
{
    return [self stepToTapViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    return [self stepToTapViewWithAccessibilityLabel:label value:nil traits:traits];
}

+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
{
    NSString *description = nil;
    if (value.length) {
        description = [NSString stringWithFormat:@"Tap view with accessibility label \"%@\" and accessibility value \"%@\"", label, value];
    } else {
        description = [NSString stringWithFormat:@"Tap view with accessibility label \"%@\"", label];
    }

    // After tapping the view we want to wait a short period to allow things to settle (animations and such). We can't do this using CFRunLoopRunInMode() because certain things, such as the built-in media picker, do things with the run loop that are not compatible with this kind of wait. Instead we leverage the way KIF hooks into the existing run loop by returning "wait" results for the desired period.
    const NSTimeInterval quiesceWaitInterval = 0.5;
    __block NSTimeInterval quiesceStartTime = 0.0;
    
    __block UIView *view = nil;
    
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {

        // If we've already tapped the view and stored it to a variable, and we've waited for the quiesce time to elapse, then we're done.
        if (view) {
            KIFTestWaitCondition(([NSDate timeIntervalSinceReferenceDate] - quiesceStartTime) >= quiesceWaitInterval, error, @"Waiting for view to become the first responder.");
            return KIFTestStepResultSuccess;
        }

        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:value tappable:YES traits:traits error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }

        view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Failed to find view for accessibility element with label \"%@\"", label);

        if (![self _isUserInteractionEnabledForView:view]) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"View with accessibility label \"%@\" is not enabled for interaction", label], NSLocalizedDescriptionKey, nil]] autorelease];
            }
            return KIFTestStepResultWait;
        }

        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];

        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestWaitCondition(!isnan(tappablePointInElement.x), error, @"The element with accessibility label %@ is not tappable", label);
        [view tapAtPoint:tappablePointInElement];

        KIFTestCondition(![view canBecomeFirstResponder] || [view isDescendantOfFirstResponder], error, @"Failed to make the view %@ which contains the accessibility element \"%@\" into the first responder", view, label);

        quiesceStartTime = [NSDate timeIntervalSinceReferenceDate];

        KIFTestWaitCondition(NO, error, @"Waiting for the view to settle.");
    }];
}

+ (id)stepToTapScreenAtPoint:(CGPoint)screenPoint;
{
    NSString *description = [NSString stringWithFormat:@"Tap screen at point \"%@\"", NSStringFromCGPoint(screenPoint)];
    
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        // Try all the windows until we get one back that actually has something in it at the given point
        UIView *view = nil;
        for (UIWindow *window in [[[UIApplication sharedApplication] windows] reverseObjectEnumerator]) {
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

+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
{
    return [self stepToEnterText:text intoViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone expectedResult:nil];
}

+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult;
{
    NSString *description = [NSString stringWithFormat:@"Type the text \"%@\" into the view with accessibility label \"%@\"", text, label];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:nil tappable:YES traits:traits error:error];
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
            
            if (![self _enterCharacter:characterString]) {
                // Attempt to cheat if we couldn't find the character
                if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
                    NSLog(@"KIF: Unable to find keyboard key for %@. Inserting manually.", characterString);
                    [(UITextField *)view setText:[[(UITextField *)view text] stringByAppendingString:characterString]];
                } else {
                    KIFTestCondition(NO, error, @"Failed to find key for character \"%@\"", characterString);
                }
            }
        }
        
        // This is probably a UITextField- or UITextView-ish view, so make sure it worked
        if ([view respondsToSelector:@selector(text)]) {
            // We trim \n and \r because they trigger the return key, so they won't show up in the final product on single-line inputs
            NSString *expected = [expectedResult ? expectedResult : text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSString *actual = [[view performSelector:@selector(text)] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            KIFTestCondition([actual isEqualToString:expected], error, @"Failed to actually enter text \"%@\" in field; instead, it was \"%@\"", text, actual);
        }
        
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToSelectPickerViewRowWithTitle:(NSString *)title;
{
    NSString *description = [NSString stringWithFormat:@"Select the \"%@\" item from the picker", title];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
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
                    UILabel *label = (labels.count > 0 ? [labels objectAtIndex:0] : nil);
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

+ (id)stepToSetOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label;
{
    NSString *description = [NSString stringWithFormat:@"Toggle the switch with accessibility label \"%@\" to %@", label, switchIsOn ? @"ON" : @"OFF"];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:nil tappable:YES traits:UIAccessibilityTraitNone error:error];
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

+ (id)stepToDismissPopover;
{
    return [self stepWithDescription:@"Dismiss the popover" executionBlock:^(KIFTestStep *step, NSError **error) {
        const NSTimeInterval tapDelay = 0.05;
        NSArray *windows = [[UIApplication sharedApplication] windows];
        KIFTestCondition(windows.count, error, @"Failed to find any windows in the application");
        UIView *dimmingView = [[[windows objectAtIndex:0] subviewsWithClassNamePrefix:@"UIDimmingView"] lastObject];
        [dimmingView tapAtPoint:CGPointMake(50.0f, 50.0f)];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, tapDelay, false);
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToSimulateMemoryWarning;
{
    return [KIFTestStep stepWithDescription:@"Simulate a memory warning" executionBlock:^(KIFTestStep *step, NSError **error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath
{
    NSString *description = [NSString stringWithFormat:@"Step to tap row %d in tableView with label %@", [indexPath row], tableViewLabel];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:tableViewLabel];
        KIFTestCondition(element, error, @"View with label %@ not found", tableViewLabel);
        UITableView *tableView = (UITableView*)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");
        
        KIFTestCondition(tableView, error, @"Table view with label %@ not found", tableViewLabel);
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
        [tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
        
        return KIFTestStepResultSuccess;
    }];
}

#pragma mark Step Collections

+ (NSArray *)stepsToChoosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Choose Photo"]];
    
    // This is basically the same as the step to tap with an accessibility label except that the accessibility labels for the albums have the number of photos appended to the end, such as "My Photos (3)." This means that we have to do a prefix match rather than an exact match.
    NSString *description = [NSString stringWithFormat:@"Select the \"%@\" photo album", albumName];
    [steps addObject:[KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        NSString *labelPrefix = [NSString stringWithFormat:@"%@,   (", albumName];
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementMatchingBlock:^(UIAccessibilityElement *element) {
            return [element.accessibilityLabel hasPrefix:labelPrefix];
        }];
        
        KIFTestWaitCondition(element, error, @"Failed to find photo album with name %@", albumName);
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Failed to find view for photo album with name %@", albumName);
        
        if (![self _isUserInteractionEnabledForView:view]) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Album picker is not enabled for interaction"], NSLocalizedDescriptionKey, nil]] autorelease];
            }
            return KIFTestStepResultWait;
        }
        
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        CGPoint tappablePointInElement = [view tappablePointInRect:elementFrame];
        
        [view tapAtPoint:tappablePointInElement];
        
        return KIFTestStepResultSuccess;
    }]];
    
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:0.5 description:@"Wait for media picker view controller to be pushed."]];
    
    // Tap the desired photo in the grid
    // TODO: This currently only works for the first page of photos. It should scroll appropriately at some point.
    const CGFloat headerHeight = 64.0;
    const CGSize thumbnailSize = CGSizeMake(75.0, 75.0);
    const CGFloat thumbnailMargin = 5.0;
    CGPoint thumbnailCenter;
    thumbnailCenter.x = thumbnailMargin + (MAX(0, column - 1) * (thumbnailSize.width + thumbnailMargin)) + thumbnailSize.width / 2.0;
    thumbnailCenter.y = headerHeight + thumbnailMargin + (MAX(0, row - 1) * (thumbnailSize.height + thumbnailMargin)) + thumbnailSize.height / 2.0;
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:thumbnailCenter]];
    
    // Dismiss the resize UI
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Choose"]];
    
    return steps;
}

#pragma mark Initialization

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.timeout = [[self class] defaultTimeout];
    
    return self;
}

- (void)dealloc;
{
    [executionBlock release];
    executionBlock = nil;
    [description release];
    description = nil;
    [notificationName release];
    notificationName = nil;
    [notificationObject release];
    notificationObject = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (KIFTestStepResult)executeAndReturnError:(NSError **)error;
{    
    KIFTestStepResult result = KIFTestStepResultFailure;
    
    if (self.executionBlock) {
        @try {
            result = self.executionBlock(self, error);
        }
        @catch (id exception) {
            // We need to catch exceptions and things like NSInternalInconsistencyException, which is actually an NSString
            KIFTestCondition(NO, error, @"Step threw exception: %@", exception);
        }
    }
    
    return result;
}

- (void)cleanUp;
{
    if (notificationName || notificationObject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:notificationObject];    
    }
}

#pragma mark Private Methods

- (void)_onObservedNotification:(NSNotification *)notification;
{
    self.notificationOccurred = YES;
}

+ (BOOL)_isUserInteractionEnabledForView:(UIView *)view;
{
    BOOL isUserInteractionEnabled = view.userInteractionEnabled;
    
    // Navigation item views don't have user interaction enabled, but their parent nav bar does and will forward the event
    if (!isUserInteractionEnabled && [view isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
        // If this view is inside a nav bar, and the nav bar is enabled, then consider it enabled
        UIView *navBar = [view superview];
        while (navBar && ![navBar isKindOfClass:[UINavigationBar class]]) {
            navBar = [navBar superview];
        }
        if (navBar && navBar.userInteractionEnabled) {
            isUserInteractionEnabled = YES;
        }
    }
    
    // UIActionsheet Buttons have UIButtonLabels with userInteractionEnabled=NO inside,
    // grab the superview UINavigationButton instead.
    if (!isUserInteractionEnabled && [view isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
        UIView *button = [view superview];
        while (button && ![button isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            button = [button superview];
        }
        if (button && button.userInteractionEnabled) {
            isUserInteractionEnabled = YES;
        }
    }
    
    return isUserInteractionEnabled;
}

+ (NSString *)_representedKeyboardStringForCharacter:(NSString *)characterString;
{
    // Interpret control characters appropriately
    if ([characterString isEqual:@"\b"]) {
        characterString = @"Delete";
    } 
    
    return characterString;
}

+ (BOOL)_enterCharacter:(NSString *)characterString;
{
    return [self _enterCharacter:characterString history:[NSMutableDictionary dictionary]];
}

+ (BOOL)_enterCharacter:(NSString *)characterString history:(NSMutableDictionary *)history;
{
    const NSTimeInterval keystrokeDelay = 0.05f;
    
    // Each key on the keyboard does not have its own view, so we have to ask for the list of keys,
    // find the appropriate one, and tap inside the frame of that key on the main keyboard view.
    if (!characterString.length) {
        return YES;
    }
    
    UIWindow *keyboardWindow = [[UIApplication sharedApplication] keyboardWindow];
    UIView *keyboardView = [[keyboardWindow subviewsWithClassNamePrefix:@"UIKBKeyplaneView"] lastObject];
    
    // If we didn't find the standard keyboard view, then we may have a custom keyboard
    if (!keyboardView) {
        return [self _enterCustomKeyboardCharacter:characterString];
    }
    id /*UIKBKeyplane*/ keyplane = [keyboardView valueForKey:@"keyplane"];
    BOOL isShiftKeyplane = [[keyplane valueForKey:@"isShiftKeyplane"] boolValue];
    
    NSMutableArray *unvisitedForKeyplane = [history objectForKey:[NSValue valueWithNonretainedObject:keyplane]];
    if (!unvisitedForKeyplane) {
        unvisitedForKeyplane = [NSMutableArray arrayWithObjects:@"More", @"International", nil];
        if (!isShiftKeyplane) {
            [unvisitedForKeyplane insertObject:@"Shift" atIndex:0];
        }
        [history setObject:unvisitedForKeyplane forKey:[NSValue valueWithNonretainedObject:keyplane]];
    }
    
    NSArray *keys = [keyplane valueForKey:@"keys"];
    
    // Interpret control characters appropriately
    characterString = [self _representedKeyboardStringForCharacter:characterString];
    
    id keyToTap = nil;
    id modifierKey = nil;
    NSString *selectedModifierRepresentedString = nil;
    
    while (YES) {
        for (id/*UIKBKey*/ key in keys) {
            NSString *representedString = [key valueForKey:@"representedString"];
            
            // Find the key based on the key's represented string
            if ([representedString isEqual:characterString]) {
                keyToTap = key;
            }
            
            if (!modifierKey && unvisitedForKeyplane.count && [[unvisitedForKeyplane objectAtIndex:0] isEqual:representedString]) {
                modifierKey = key;
                selectedModifierRepresentedString = representedString;
                [unvisitedForKeyplane removeObjectAtIndex:0];
            }
        }
        
        if (keyToTap) {
            break;
        }
        
        if (modifierKey) {
            break;
        }
        
        if (!unvisitedForKeyplane.count) {
            return NO;
        }
        
        // If we didn't find the key or the modifier, then this modifier must not exist on this keyboard. Remove it.
        [unvisitedForKeyplane removeObjectAtIndex:0];
    }
    
    if (keyToTap) {
        [keyboardView tapAtPoint:CGPointCenteredInRect([keyToTap frame])];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
        
        return YES;
    }
    
    // We didn't find anything, so try the symbols pane
    if (modifierKey) {
        [keyboardView tapAtPoint:CGPointCenteredInRect([modifierKey frame])];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
        
        // If we're back at a place we've been before, and we still have things to explore in the previous
        id /*UIKBKeyplane*/ newKeyplane = [keyboardView valueForKey:@"keyplane"];
        id /*UIKBKeyplane*/ previousKeyplane = [history valueForKey:@"previousKeyplane"];
        
        if (newKeyplane == previousKeyplane) {
            // Come back to the keyplane that we just tested so that we can try the other modifiers
            NSMutableArray *previousKeyplaneHistory = [history objectForKey:[NSValue valueWithNonretainedObject:newKeyplane]];
            [previousKeyplaneHistory insertObject:[history valueForKey:@"lastModifierRepresentedString"] atIndex:0];
        } else {
            [history setValue:keyplane forKey:@"previousKeyplane"];
            [history setValue:selectedModifierRepresentedString forKey:@"lastModifierRepresentedString"];
        }
        
        return [self _enterCharacter:characterString history:history];
    }
    
    return NO;
}

+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;
{
    const NSTimeInterval keystrokeDelay = 0.05f;
    
    if (!characterString.length) {
        return YES;
    }
    
    characterString = [self _representedKeyboardStringForCharacter:characterString];
    
    // For custom keyboards, use the classic methods of looking up views based on accessibility labels
    UIWindow *keyboardWindow = [[UIApplication sharedApplication] keyboardWindow];
    
    UIAccessibilityElement *element = [keyboardWindow accessibilityElementWithLabel:characterString];
    if (!element) {
        return NO;
    }
    
    UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
    CGRect keyFrame = [view.window convertRect:[element accessibilityFrame] toView:view];
    [view tapAtPoint:CGPointCenteredInRect(keyFrame)];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
    
    return YES;
}

+ (UIAccessibilityElement *)_accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value tappable:(BOOL)mustBeTappable traits:(UIAccessibilityTraits)traits error:(out NSError **)error;
{
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:value traits:traits];
    if (!element) {
        if (error) {
            // For purposes of a better error message, see if we can find the view, just not a view with the specified value.
            if (value && [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:traits]) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Found an accessibility element with the label \"%@\", but not with the value \"%@\"", label, value], NSLocalizedDescriptionKey, nil]] autorelease];
                
            // Check the traits, too.
            } else if (traits != UIAccessibilityTraitNone && [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone]) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Found an accessibility element with the label \"%@\", but not with the traits \"%d\"", label, traits], NSLocalizedDescriptionKey, nil]] autorelease];
                
            } else {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Failed to find accessibility element with the label \"%@\"", label], NSLocalizedDescriptionKey, nil]] autorelease];
            }
        }
        return nil;
    }
    
    // Make sure the element is visible
    UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
    if (!view) {
        if (error) {
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat: @"Cannot find view containing accessibility element with the label \"%@\"", label], NSLocalizedDescriptionKey, nil]] autorelease];
        }
        return nil;
    }
    
    // Scroll the view to be visible if necessary
    UIScrollView *scrollView = (UIScrollView *)view;
    while (scrollView && ![scrollView isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *)scrollView.superview;
    }
    if (scrollView) {
        if ((UIAccessibilityElement *)view == element) {
            [scrollView scrollViewToVisible:view animated:YES];
        } else {
            CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:scrollView];            
            [scrollView setContentOffset:CGPointMake(0,  elementFrame.origin.y) animated:YES];
        }
        
        // Give the scroll view a small amount of time to perform the scroll.
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.3, false);
    }
    
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        if (error) {
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Application is ignoring interaction events", NSLocalizedDescriptionKey, nil]] autorelease];
        }
        return nil;
    }
    
    // There are some issues with the tappability check in UIWebViews, so if the view is a UIWebView we will just skip the check.
    if ([NSStringFromClass([view class]) isEqualToString:@"UIWebBrowserView"]) {
        return element;
    }

    if (mustBeTappable) {
        // Make sure the view is tappable
        if (![view isTappable]) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Accessibility element with label \"%@\" is not tappable. It may be blocked by other views.", label], NSLocalizedDescriptionKey, nil]] autorelease];
            }
            return nil;
        }
    } else {
        // If we don't require tappability, at least make sure it's not hidden
        if ([view isHidden]) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Accessibility element with label \"%@\" is hidden.", label], NSLocalizedDescriptionKey, nil]] autorelease];
            }
            return nil;
        }
    }
    
    return element;
}

@end
