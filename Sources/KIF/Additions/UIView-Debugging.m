//
//  UIView+Debugging.m
//  KIF
//
//  Created by Graeme Arthur on 02/05/15.
//

#import "UIView-Debugging.h"
#import "KIFEventVisualizer.h"
#import "KIFTouchVisualizerView.h"
#import <Foundation/Foundation.h>

@implementation UIView (Debugging)

+(void)printViewHierarchy {
    printf("%s", [self viewHierarchyDescription].UTF8String);
}

+ (NSString *)viewHierarchyDescription {
    NSArray* windows = [UIApplication sharedApplication].windows;
    NSMutableString *result = [[NSMutableString alloc] init];
    if(windows.count == 1) {
        [windows[0] _KIF_appendViewHierarchy:result];
    } else {
        //more than one window, also print some information about each window
        for (UIWindow* window in windows) {
            [result appendFormat:@"Window level %@", @(window.windowLevel)];
            if(window.isKeyWindow) [result appendString:@" (key window)"];
            [result appendString:@"\n"];
            [window _KIF_appendViewHierarchy:result];
            [result appendString:@"\n"];
        }
    }
    return result;
}


- (void)printViewHierarchy {
    NSMutableString *result = [NSMutableString new];
    [self _KIF_appendViewHierarchy:result];
    printf("%s", result.UTF8String);
}

- (void)_KIF_appendViewHierarchy:(NSMutableString *)result {
    [self _KIF_viewHierarchyWithIndentation:0 result:result];
}

- (void)_KIF_viewHierarchyWithIndentation:(int)indent result:(NSMutableString *)result {

    // Don't print the touch visualizer view or it's subviews.
    if([self isKindOfClass:[KIFTouchVisualizerView class]]) {
        return;
    }

    [self _KIF_appendIndentation:indent result:result];
    [self _KIF_appendClassName:result];

    [self _KIF_appendAccessibilityInfo:result];

    if(self.hidden) {
        [result appendString:@" (invisible)"];
    }

    if([self isKindOfClass:[UIImageView class]]) {
        [self _KIF_appendImageHighlightedState:result];
    }

    if([self isKindOfClass:[UIControl class]]) {
        [self _KIF_appendControlState:result];
    }
    
    if([self isKindOfClass:[UIDatePicker class]]) {
        [self _KIF_appendDatePickerState:result];
    }

    [result appendString:@"\n"];

    [self _KIF_appendAccessibilityElementsWithIndentation:indent result:result];
    
    // We do not want to print the view hierarchy under this class as it is too large and not helpful.
    if([self isKindOfClass:[NSClassFromString(@"_UIDatePickerView") class]]) {
        return;
    }
    
    for (UIView *subview in self.subviews) {
        [subview _KIF_viewHierarchyWithIndentation:indent+1 result:result];
    }
}

- (void)_KIF_appendIndentation:(int)indent result:(NSMutableString *)result{
    for(int i = 0; i < indent; ++i) {
        [result appendString:@"|\t"];
    }
}

- (void)_KIF_appendClassName:(NSMutableString *)result {
    [result appendString:NSStringFromClass([self class])];
}

- (void)_KIF_appendAccessibilityInfo:(NSMutableString *)result {
    NSString* label = self.accessibilityLabel;
    NSString* identifier = self.accessibilityIdentifier;
    if(label != nil) {
        [result appendFormat:@", label: %@", label];
    } 
    
    if(identifier != nil) {
        [result appendFormat:@", identifier: %@", identifier];
    }
}

- (void)_KIF_appendImageHighlightedState:(NSMutableString *)result {
    if(((UIImageView*)self).highlighted) {
        [result appendString:@" (highlighted)"];
    } else {
        [result appendString:@" (not highlighted)"];
    }
}

- (void)_KIF_appendControlState:(NSMutableString *)result {
    UIControl* ctrl = (UIControl*)self;
    [result appendString:ctrl.enabled ? @" (enabled)" : @" (not enabled)"];
    [result appendString:ctrl.selected ? @" (selected)" : @" (not selected)"];
    [result appendString:ctrl.highlighted ? @" (highlighted)" : @" (not highlighted)" ];
}

- (void)_KIF_appendDatePickerState:(NSMutableString *)result {
    UIDatePicker *datePicker = (UIDatePicker *)self;
    [result appendFormat:@" (date range: %@ - %@)",
     datePicker.minimumDate ? datePicker.minimumDate.description : @"no minimum",
     datePicker.maximumDate ? datePicker. maximumDate.description : @"no maximum"];


    [result appendString:@" (mode:"];
    
    switch (datePicker.datePickerMode) {
        case UIDatePickerModeTime:
            [result appendString:@" UIDatePickerModeTime"];
            break;
            
        case UIDatePickerModeDate:
            [result appendString:@" UIDatePickerModeDate"];
            break;
            
        case UIDatePickerModeDateAndTime:
            [result appendString:@" UIDatePickerModeDateAndTime"];
            break;
            
        case UIDatePickerModeCountDownTimer:
            [result appendString:@" UIDatePickerModeCountDownTimer"];
            break;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170400 //__IPHONE_17_4
        case UIDatePickerModeYearAndMonth:
            [result appendString:@" UIDatePickerModeYearAndMonth"];
            break;
#endif
    }
    [result appendString:@")"];
    [result appendFormat:@" (minute interval: %@)",  @(datePicker.minuteInterval)];
}

- (void)_KIF_appendAccessibilityElementsWithIndentation:(int)indent result:(NSMutableString *)result {
    NSInteger numOfAccElements = self.accessibilityElementCount;
    if(numOfAccElements != NSNotFound) {
        for (NSInteger i = 0; i < numOfAccElements; ++i) {
            [self _KIF_appendIndentation:indent result:result];
            UIAccessibilityElement *e = [(UIAccessibilityElement*)self accessibilityElementAtIndex:i];
            [result appendFormat:@"%@, label: %@", NSStringFromClass([e class]), e.accessibilityLabel];
            if(e.accessibilityValue && e.accessibilityValue.length > 0) {
                [result appendFormat:@", value: %@", e.accessibilityValue];
            }
            if(e.accessibilityHint && e.accessibilityHint.length > 0) {
                [result appendFormat:@", hint: %@", e.accessibilityHint];
            }
            [result appendString:@", "];
            [self _KIF_appendAccessibilityTraits:e.accessibilityTraits result:result];
            [result appendString:@"\n"];
        }
    }
}

- (void)_KIF_appendAccessibilityTraits:(UIAccessibilityTraits)traits result:(NSMutableString *)result {

    [result appendString:@"traits: "];
    NSMutableArray<NSString *> *components = [NSMutableArray new];
    if(traits == UIAccessibilityTraitNone) {
        [components addObject:@"none"];
    }
    if(traits & UIAccessibilityTraitButton) {
        [components addObject:@"button"];
    }
    if(traits & UIAccessibilityTraitLink) {
        [components addObject:@"link"];
    }
    if(traits & UIAccessibilityTraitHeader) {
        [components addObject:@"header"];
    }
    if(traits & UIAccessibilityTraitSearchField) {
        [components addObject:@"search field"];
    }
    if(traits & UIAccessibilityTraitImage) {
        [components addObject:@"image"];
    }
    if(traits & UIAccessibilityTraitSelected) {
        [components addObject:@"selected"];
    }
    if(traits & UIAccessibilityTraitPlaysSound) {
        [components addObject:@"plays sound"];
    }
    if(traits & UIAccessibilityTraitKeyboardKey) {
        [components addObject:@"keyboard key"];
    }
    if(traits & UIAccessibilityTraitStaticText) {
        [components addObject:@"static text"];
    }
    if(traits & UIAccessibilityTraitSummaryElement) {
        [components addObject:@"summary element"];
    }
    if(traits & UIAccessibilityTraitNotEnabled) {
        [components addObject:@"not enabled"];
    }
    if(traits & UIAccessibilityTraitUpdatesFrequently) {
        [components addObject:@"updates frequently"];
    }
    if(traits & UIAccessibilityTraitStartsMediaSession) {
        [components addObject:@"starts media session"];
    }
    if(traits & UIAccessibilityTraitAdjustable) {
        [components addObject:@"adjustable"];
    }
    if(traits & UIAccessibilityTraitAllowsDirectInteraction) {
        [components addObject:@"allows direct interaction"];
    }
    if(traits & UIAccessibilityTraitCausesPageTurn) {
        [components addObject:@"causes page turn"];
    }

    if(components.count == 0) {
        [result appendFormat:@"unknown flags (0x%llx)", traits];
    } else {
        [result appendString:[components componentsJoinedByString:@", "]];
    }
}

@end
