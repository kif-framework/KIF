//
//  UIView+Debugging.m
//  KIF
//
//  Created by Graeme Arthur on 02/05/15.
//

#import "UIView-Debugging.h"
#import "KIFEventVisualizer.h"
#import "KIFTouchVisualizerView.h"

@implementation UIView (Debugging)

+(void)printViewHierarchy {
    NSArray* windows = [UIApplication sharedApplication].windows;
    if(windows.count == 1) {
        [windows[0] printViewHierarchy];
    } else {
        //more than one window, also print some information about each window
        for (UIWindow* window in windows) {
            printf("Window level %f", window.windowLevel);
            if(window.isKeyWindow) printf(" (key window)");
            printf("\n");
            [window printViewHierarchy];
            printf("\n");
        }
    }
}

- (void)printViewHierarchy {
    [self printViewHierarchyWithIndentation:0];
}

- (void)printViewHierarchyWithIndentation:(int)indent {
    
    // Don't print the touch visualizer view or it's subviews.
    if([self isKindOfClass:[KIFTouchVisualizerView class]]) {
        return;
    }

    [self printIndentation:indent];
    [self printClassName];

    [self printAccessibilityInfo];

    if(self.hidden) {
        printf(" (invisible)");
    }

    if([self isKindOfClass:[UIImageView class]]) {
        [self printImageHighlightedState];
    }

    if([self isKindOfClass:[UIControl class]]) {
        [self printControlState];
    }
    
    if([self isKindOfClass:[UIDatePicker class]]) {
        [self printDatePickerState];
    }
    
    printf("\n");
    
    [self printAccessibilityElementsWithIndentation:indent];
    
    // We do not want to print the view heirarchy under this class as it is too large and not helpful.
    if([self isKindOfClass:[NSClassFromString(@"_UIDatePickerView") class]]) {
        return;
    }
    
    for (UIView *subview in self.subviews) {
        [subview printViewHierarchyWithIndentation:indent+1];
    }
}

- (void)printIndentation:(int)indent {
    for(int i = 0; i < indent; ++i) {
        printf("|\t");
    }
}

- (void)printClassName {
    NSString* name = NSStringFromClass([self class]);
    printf("%s", name.UTF8String);
}

- (void)printAccessibilityInfo {
    NSString* label = self.accessibilityLabel;
    NSString* identifier = self.accessibilityIdentifier;
    if(label != nil) {
        printf(", label: %s", label.UTF8String);
    } 
    
    if(identifier != nil) {
        printf(", identifier: %s", identifier.UTF8String);
    }
}

- (void)printImageHighlightedState {
    if(((UIImageView*)self).highlighted) {
        printf(" (highlighted)");
    } else {
        printf(" (not highlighted)");
    }
}

- (void)printControlState {
    UIControl* ctrl = (UIControl*)self;
    ctrl.enabled ? printf(" (enabled)") : printf(" (not enabled)");
    ctrl.selected ? printf(" (selected)") : printf(" (not selected)");
    ctrl.highlighted ? printf(" (highlighted)") : printf(" (not highlighted)");
}

- (void)printDatePickerState {
    UIDatePicker *datePicker = (UIDatePicker *)self;
    printf(" (date range:");
    datePicker.minimumDate ? printf(" %s", datePicker.minimumDate.description.UTF8String) : printf(" no minimum");
    printf(" -");
    datePicker.maximumDate ? printf(" %s", datePicker.minimumDate.description.UTF8String) : printf(" no maximum");
    printf(")");
    printf(" (mode:");
    
    switch (datePicker.datePickerMode) {
        case UIDatePickerModeTime:
            printf(" UIDatePickerModeTime");
            break;
            
        case UIDatePickerModeDate:
            printf(" UIDatePickerModeDate");
            break;
            
        case UIDatePickerModeDateAndTime:
            printf(" UIDatePickerModeDateAndTime");
            break;
            
        case UIDatePickerModeCountDownTimer:
            printf(" UIDatePickerModeCountDownTimer");
            break;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 170400 //__IPHONE_17_4
        case UIDatePickerModeYearAndMonth:
            printf(" UIDatePickerModeYearAndMonth");
            break;
#endif
    }
    printf(")");
    printf(" (minute interval: %s)", @(datePicker.minuteInterval).stringValue.UTF8String);
}

- (void)printAccessibilityElementsWithIndentation:(int)indent {
    NSInteger numOfAccElements = self.accessibilityElementCount;
    if(numOfAccElements != NSNotFound) {
        for (NSInteger i = 0; i < numOfAccElements; ++i) {
            [self printIndentation:indent];
            UIAccessibilityElement *e = [(UIAccessibilityElement*)self accessibilityElementAtIndex:i];
            printf("%s, label: %s", NSStringFromClass([e class]).UTF8String, e.accessibilityLabel.UTF8String);
            if(e.accessibilityValue && e.accessibilityValue.length > 0) {
                printf(", value: %s", e.accessibilityValue.UTF8String);
            }
            if(e.accessibilityHint && e.accessibilityHint.length > 0) {
                printf(", hint: %s", e.accessibilityHint.UTF8String);
            }
            printf(", ");
            [self printAccessibilityTraits:e.accessibilityTraits];
            printf("\n");
        }
    }
}

- (void)printAccessibilityTraits:(UIAccessibilityTraits)traits {
    
    printf("traits: ");
    bool didPrintOne = false;
    if(traits == UIAccessibilityTraitNone) {
        printf("none");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitButton) {
        if(didPrintOne) printf(", ");
        printf("button");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitLink) {
        if(didPrintOne) printf(", ");
        printf("link");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitHeader) {
        if(didPrintOne) printf(", ");
        printf("header");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitSearchField) {
        if(didPrintOne) printf(", ");
        printf("search field");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitImage) {
        if(didPrintOne) printf(", ");
        printf("image");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitSelected) {
        if(didPrintOne) printf(", ");
        printf("selected");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitPlaysSound) {
        if(didPrintOne) printf(", ");
        printf("plays sound");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitKeyboardKey) {
        if(didPrintOne) printf(", ");
        printf("keyboard key");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitStaticText) {
        if(didPrintOne) printf(", ");
        printf("static text");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitSummaryElement) {
        if(didPrintOne) printf(", ");
        printf("summary element");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitNotEnabled) {
        if(didPrintOne) printf(", ");
        printf("not enabled");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitUpdatesFrequently) {
        if(didPrintOne) printf(", ");
        printf("updates frequently");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitStartsMediaSession) {
        if(didPrintOne) printf(", ");
        printf("starts media session");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitAdjustable) {
        if(didPrintOne) printf(", ");
        printf("adjustable");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitAllowsDirectInteraction) {
        if(didPrintOne) printf(", ");
        printf("allows direct interaction");
        didPrintOne = true;
    }
    if(traits & UIAccessibilityTraitCausesPageTurn) {
        if(didPrintOne) printf(", ");
        printf("causes page turn");
        didPrintOne = true;
    }
    if(!didPrintOne) {
        printf("unknown flags (0x%llx)", traits);
    }
}

@end
