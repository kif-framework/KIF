//
//  KIFTestStep.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import "KIFTestStep.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIScrollView-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"


@interface KIFTestStep ()

@property (nonatomic, copy) KIFTestStepExecutionBlock executionBlock;

+ (BOOL)_enterCharacter:(NSString *)characterString;
+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;

+ (UIAccessibilityElement *)_tappableAccessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits error:(out NSError **)error;

@end


@implementation KIFTestStep

@synthesize description;
@synthesize executionBlock;
@synthesize timeout;

#pragma mark Static Methods

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

+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label;
{
    return [self stepToWaitForTappableViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    NSString *description = [NSString stringWithFormat:@"Wait for view with accessibility label \"%@\"", label];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [self _tappableAccessibilityElementWithLabel:label accessibilityValue:nil traits:traits error:error];
        return (element ? KIFTestStepResultSuccess : KIFTestStepResultWait);
    }];
}

+ (id)stepToWaitForTimeInterval:(NSTimeInterval)interval description:(NSString *)description;
{
    // In general, we should discourage use of a step like this. It's pragmatic to include it though.
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, interval, false);
        return KIFTestStepResultSuccess;        
    }];
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
    
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UIAccessibilityElement *element = [self _tappableAccessibilityElementWithLabel:label accessibilityValue:value traits:traits error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Failed to find view for accessibility element with label \"%@\"", label);

        if (!view.userInteractionEnabled) {
            if (error) {
                *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"View with accessibility label \"%@\" is not enabled for interaction", label], NSLocalizedDescriptionKey, nil]] autorelease];
            }
            return KIFTestStepResultWait;
        }
        
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        //NSLog(@"Element frame: %@", NSStringFromCGRect(elementFrame));
        
        [view tapAtPoint:CGPointCenteredInRect(elementFrame)];
        
        // Verify that we successfully selected the view
        if (![view canBecomeFirstResponder]) {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
            return KIFTestStepResultSuccess;
        }
        
        KIFTestCondition([view isAncestorOfFirstResponder], error, @"Failed to make the view %@ which contains the accessibility element \"%@\" into the first responder", view, label);
  
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
{
    return [self stepToEnterText:text intoViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
{
    NSString *description = [NSString stringWithFormat:@"Type the text \"%@\" into the view with accessibility label \"%@\"", text, label];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UIAccessibilityElement *element = [self _tappableAccessibilityElementWithLabel:label accessibilityValue:nil traits:traits error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Cannot find view with accessibility label \"%@\"", label);
                
        CGRect elementFrame = [view.window convertRect:element.accessibilityFrame toView:view];
        [view tapAtPoint:CGPointCenteredInRect(elementFrame)];
        KIFTestCondition([view isAncestorOfFirstResponder], error, @"Failed to make the view with accessibility label \"%@\" the first responder. First responder is %@", label, [[[UIApplication sharedApplication] keyWindow] firstResponder]);
        
        // Wait for the keyboard
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        
        for (NSUInteger characterIndex = 0; characterIndex < [text length]; characterIndex++) {
            NSString *characterString = [text substringWithRange:NSMakeRange(characterIndex, 1)];
            
            KIFTestCondition([self _enterCharacter:characterString], error, @"Failed to find key for character \"%@\"", characterString);
        }
        
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToSelectPickerViewRowWithTitle:(NSString *)title;
{
    NSString *description = [NSString stringWithFormat:@"Select the \"%@\" item from the picker", title];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        // Find the picker view
        UIPickerView *pickerView = (UIPickerView *)[[[UIApplication sharedApplication] pickerViewWindow] subviewWithClassNameOrSuperClassNamePrefix:@"UIPickerView"];
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
                    UILabel *label = (UILabel *)[rowView subviewWithClassNameOrSuperClassNamePrefix:@"UILabel"];
                    rowTitle = label.text;
                }
                
                if ([rowTitle isEqual:title]) {
                    [pickerView selectRow:rowIndex inComponent:componentIndex animated:YES];
                    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
                    
                    // Tap in the middle of the picker view to select the item
                    [pickerView tap];
                    
                    // Tap the done button
                    UIButton *doneButton = (UIButton *)[[[UIApplication sharedApplication] pickerViewWindow] accessibilityElementWithLabel:@"Done"];
                    KIFTestCondition(doneButton, error, @"Failed to find the \"Done\" button after selecting the picker value \"%@\"", title);
                    
                    [doneButton tap];
                    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);                    
                    
                    return KIFTestStepResultSuccess;
                }
            }
        }
        
        KIFTestCondition(NO, error, @"Failed to find picker view value with title \"%@\"", title);
        return KIFTestStepResultFailure;
    }];
}

#pragma mark Initialization

- (id)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.timeout = 10.0f;
    
    return self;
}

#pragma mark Public Methods

- (KIFTestStepResult)executeAndReturnError:(NSError **)error
{
    KIFTestStepResult result = KIFTestStepResultFailure;
    
    if (self.executionBlock) {
        result = self.executionBlock(self, error);
    }
    
    return result;
}

#pragma mark Private Methods

+ (BOOL)_enterCharacter:(NSString *)characterString;
{
    const NSTimeInterval keystrokeDelay = 0.05f;
    
    // Each key on the keyboard does not have its own view, so we have to ask for the list of keys,
    // find the appropriate one, and tap inside the frame of that key on the main keyboard view.
    if (!characterString.length) {
        return YES;
    }
    
    UIWindow *keyboardWindow = [[UIApplication sharedApplication] keyboardWindow];
    UIView *keyboardView = [keyboardWindow subviewWithClassNamePrefix:@"UIKBKeyplaneView"];
    
    // If we didn't find the standard keyboard view, then we may have a custom keyboard
    if (!keyboardView) {
        return [self _enterCustomKeyboardCharacter:characterString];
    }
    id /*UIKBKeyplane*/ keyplane = [keyboardView valueForKey:@"keyplane"];
    BOOL isShowingCapitals = [[keyplane valueForKey:@"isShiftKeyplane"] boolValue];
    BOOL isCapitalLetter = isupper([characterString characterAtIndex:0]);
    
    NSArray *keys = [keyplane valueForKey:@"keys"];
    NSString *matchingCharacterString = (isShowingCapitals ? [characterString uppercaseString] : [characterString lowercaseString]);
    
    id keyToTap = nil;
    id shiftKey = nil;
    id moreKey = nil;
    for (id/*UIKBKey*/ key in keys) {
        NSString *representedString = [key valueForKey:@"representedString"];
        // Find the key based on the key's represented string
        if ([representedString isEqual:matchingCharacterString]) {
            keyToTap = key;
            
            if (isShowingCapitals == isCapitalLetter) {
                break;
            }
        }
        
        if ([representedString isEqual:@"Shift"]) {
            shiftKey = key;
        }
        
        if ([representedString isEqual:@"More"]) {
            moreKey = key;
        }
    }
    
    if (keyToTap) {
        if (isShowingCapitals != isCapitalLetter) {
            if (!shiftKey) {
                return NO;
            }
            [keyboardView tapAtPoint:CGPointCenteredInRect([shiftKey frame])];
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);            
        }
        
        [keyboardView tapAtPoint:CGPointCenteredInRect([keyToTap frame])];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
        
        return YES;
    }
    
    // We didn't find anything, so try the symbols pane
    if (moreKey) {
        [keyboardView tapAtPoint:CGPointCenteredInRect([moreKey frame])];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
        
        return [self _enterCharacter:characterString];
    }
    
    return NO;
}

+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;
{
    const NSTimeInterval keystrokeDelay = 0.05f;
    
    if (!characterString.length) {
        return YES;
    }
    
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

+ (UIAccessibilityElement *)_tappableAccessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits error:(out NSError **)error;
{
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:value traits:traits];
    if (!element) {
        if (error) {
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Failed to find accessibility element with label \"%@\"", label], NSLocalizedDescriptionKey, nil]] autorelease];
        }
        return nil;
    }
    
    // Make sure the element is visible
    UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
    if (!view) {
        if (error) {
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat: @"Cannot find view containing accessibility element with label \"%@\"", label], NSLocalizedDescriptionKey, nil]] autorelease];
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
            [scrollView scrollRectToVisible:elementFrame animated:YES];
        }
    }
    
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        if (error) {
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Application is ignoring interaction events", NSLocalizedDescriptionKey, nil]] autorelease];
        }
        return nil;
    }
    
    // Make sure the view is tappable
    if (![view isTappable]) {
        if (error) {
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Accessibility element with label \"%@\" is not tappable. It may be blocked by other views.", label], NSLocalizedDescriptionKey, nil]] autorelease];
        }
        return nil;
    }
    
    return element;
}

@end
