//
//  KIFUIViewActor.m
//  KIF
//
//  Created by Alex Odawa on 1/21/15.
//
//

#import "KIFUIViewTestActor_Private.h"

#import "CALayer-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "KIFEnumDefines.h"
#import "KIFSystemTestActor.h"
#import "KIFTestActor_Private.h"
#import "KIFTypist.h"
#import "KIFUIObject.h"
#import "KIFUITestActor_Private.h"
#import "NSError-KIFAdditions.h"
#import "NSPredicate+KIFAdditions.h"
#import "NSString+KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIAutomationHelper.h"
#import "UIScreen+KIFAdditions.h"
#import "UITableView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"

@interface KIFUIViewTestActor ()

@property (nonatomic, strong, readwrite) NSPredicate *predicate;
@property (nonatomic, assign) BOOL validateEnteredText;

@end

static BOOL KIFUITestActorAnimationsEnabled = YES;

@implementation KIFUIViewTestActor

NSString *const inputFieldTestString = @"Testing";

#pragma mark - Initialization

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
{
    self = [super initWithFile:file line:line delegate:delegate];
    NSParameterAssert(self);
    _validateEnteredText = YES;
    return self;
}

#pragma mark - Behavior modifiers

- (instancetype)validateEnteredText:(BOOL)validateEnteredText;
{
    self.validateEnteredText = validateEnteredText;
    return self;
}

#pragma mark - Searching for Accessibility Elements

- (instancetype)usingPredicate:(NSPredicate *)predicate;
{
    if (predicate == nil) {
        return self;
    }
    
    [self _appendPredicate:predicate];
    return  self;
}

- (instancetype)usingLabel:(NSString *)accessibilityLabel;
{
    if (accessibilityLabel == nil) {
        return self;
    }
    
    int systemVersion = [UIDevice currentDevice].systemVersion.intValue;
    NSPredicate *predicate;
    if ([accessibilityLabel rangeOfString:@"\n"].location == NSNotFound || systemVersion == 6) {
        predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            id label = [evaluatedObject accessibilityLabel];
            return [accessibilityLabel KIF_isEqualToStringOrAttributedString:label];
        }];
    }
    else {
        // On iOS 6 the accessibility label may contain line breaks, so when trying to find the
        // element, these line breaks are necessary. But on iOS 7 the system replaces them with
        // spaces. So the same test breaks on either iOS 6 or iOS 7. iOS 8 befuddles this again by
        // limiting replacement to spaces in between strings.
        // UNLESS the accessibility label is set programatically in which case the line breaks remain regardless of OS version.
        // To work around this replace the line breaks using the preferred method and try matching both.
        
        __block NSString *alternate = nil;
        if (systemVersion == 7) {
            alternate = [accessibilityLabel stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        } else {
            alternate = [accessibilityLabel stringByReplacingOccurrencesOfString:@"\\b\\n\\b" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, accessibilityLabel.length)];
        }
        
        predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            id label = [evaluatedObject accessibilityLabel];
            return ([accessibilityLabel KIF_isEqualToStringOrAttributedString:label] || [alternate KIF_isEqualToStringOrAttributedString:label]);
        }];
    }
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility label equal to \"%@\"", accessibilityLabel];
    return [self usingPredicate:predicate];
}

- (instancetype)usingIdentifier:(NSString *)accessibilityIdentifier;
{
    if (![UIAccessibilityElement instancesRespondToSelector:@selector(accessibilityIdentifier)]) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Running test on platform that does not support accessibilityIdentifier"] stopTest:YES];
    }
    
    if (accessibilityIdentifier == nil) {
        return self;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        id identifier = [evaluatedObject accessibilityIdentifier];

        return [accessibilityIdentifier KIF_isEqualToStringOrAttributedString:identifier];
    }];
    
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility identifier equal to \"%@\"", accessibilityIdentifier];

    return [self usingPredicate:predicate];
}

- (instancetype)usingTraits:(UIAccessibilityTraits)accessibilityTraits;
{
    if (accessibilityTraits == UIAccessibilityTraitNone) {
        return self;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(accessibilityTraits & %@) == %@", @(accessibilityTraits), @(accessibilityTraits)];
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility traits including \"%@\"", [UIAccessibilityElement stringFromAccessibilityTraits:accessibilityTraits]];
    
    return [self usingPredicate:predicate];
}

- (instancetype)usingAbsenceOfTraits:(UIAccessibilityTraits)accessibilityTraits;
{
    if (accessibilityTraits == UIAccessibilityTraitNone) {
        return self;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(accessibilityTraits & %@) != %@", @(accessibilityTraits), @(accessibilityTraits)];
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility traits excluding \"%@\"", [UIAccessibilityElement stringFromAccessibilityTraits:accessibilityTraits]];

    return [self usingPredicate:predicate];
}

- (instancetype)usingValue:(NSString *)accessibilityValue;
{
    if (accessibilityValue == nil) {
        return self;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *value = [evaluatedObject accessibilityValue];
        if ([value isKindOfClass:[NSAttributedString class]]) {
            value = [(NSAttributedString *)value string];
        }
        return [value isEqualToString:accessibilityValue];
    }];
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility Value equal to \"%@\"", accessibilityValue];
    
    return [self usingPredicate:predicate];
}

- (instancetype)usingFirstResponder;
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        // The current first responder can be in any application window
        for (UIWindow *window in [[UIApplication sharedApplication] windowsWithKeyWindow]) {
            if ([evaluatedObject isEqual:window.firstResponder]) {
                return YES;
            }
        }
        return NO;
    }];
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Is First Responder"];
    
    return [self usingPredicate:predicate];
}

#pragma mark - System Actions

- (void)deactivateAppForDuration:(NSTimeInterval)duration {
    [system deactivateAppForDuration:duration];
}

#if TARGET_IPHONE_SIMULATOR
- (BOOL)acknowledgeSystemAlert
{
    return [UIAutomationHelper acknowledgeSystemAlert];
}

- (BOOL)acknowledgeSystemAlertWithIndex:(NSUInteger)index
{
    return [UIAutomationHelper acknowledgeSystemAlertWithIndex: index];
}
#endif

- (void)tapStatusBar
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition(![UIApplication sharedApplication].statusBarHidden, error, @"Expected status bar to be visible.");
        return KIFTestStepResultSuccess;
    }];
    
    UIWindow *statusBarWindow = [[UIApplication sharedApplication] statusBarWindow];
    NSArray *statusBars = [statusBarWindow subviewsWithClassNameOrSuperClassNamePrefix:@"UIStatusBar"];
    
    if (statusBars.count == 0) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Could not find the status bar"] stopTest:YES];
    }
    
    [self tapAccessibilityElement:statusBars[0] inView:statusBars[0]];
}


- (void)dismissPopover
{
    const NSTimeInterval tapDelay = 0.05;
    UIWindow *window = [[UIApplication sharedApplication] dimmingViewWindow];
    if (!window) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Failed to find any dimming views in the application"] stopTest:YES];
    }
    UIView *dimmingView = [[window subviewsWithClassNamePrefix:@"UIDimmingView"] lastObject];
    [dimmingView tapAtPoint:CGPointMake(50.0f, 50.0f)];
    KIFRunLoopRunInModeRelativeToAnimationSpeed(kCFRunLoopDefaultMode, tapDelay, false);
}

#pragma mark - Waiting

- (UIView *)waitForView;
{
    return [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO].view;
}

- (void)waitForAbsenceOfView;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // If the app is ignoring interaction events, then wait before doing our analysis
        KIFTestWaitCondition(![[UIApplication sharedApplication] isIgnoringInteractionEvents], error, @"Application is ignoring interaction events.");
        
        // If the element can't be found, then we're done
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
        if (!found) {
            return KIFTestStepResultSuccess;
        }
        
        // If we found an element, but it's not associated with a view, then something's wrong. Wait it out and try again.
        KIFTestWaitCondition(found.view, error, @"Cannot find view containing accessibility element \"%@\"", found.element);
        
        // Hidden views count as absent
        KIFTestWaitCondition([found.view isHidden] || [found.view superview] == nil, error, @"Accessibility element \"%@\" is visible and not hidden.", found);
        
        return KIFTestStepResultSuccess;
    }];
}

- (UIView *)waitForTappableView;
{
    return [self predicateSearchWithRequiresMatch:YES mustBeTappable:YES].view;
}

- (void)waitToBecomeTappable;
{
    [self predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
}

- (void)waitToBecomeFirstResponder;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIResponder *firstResponder = [[[UIApplication sharedApplication] keyWindow] firstResponder];

        KIFTestWaitCondition([self.predicate evaluateWithObject:firstResponder], error, @"Expected first responder to match '%@', got '%@'", self.predicate, firstResponder);
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement * __autoreleasing *)element view:(out UIView * __autoreleasing *)view withElementMatchingPredicate:(NSPredicate *)predicate tappable:(BOOL)mustBeTappable
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withElementMatchingPredicate:predicate tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
    }];
}

#pragma mark - Wait for Animations

- (void)waitForAnimationsToFinish;
{
    [self waitForAnimationsToFinishWithTimeout:self.animationWaitingTimeout stabilizationTime:self.animationStabilizationTimeout];
}

- (void)waitForAnimationsToFinishWithTimeout:(NSTimeInterval)timeout {
    [self waitForAnimationsToFinishWithTimeout:timeout stabilizationTime:self.animationStabilizationTimeout mainThreadDispatchStabilizationTime:self.mainThreadDispatchStabilizationTimeout];
}

- (void)waitForAnimationsToFinishWithTimeout:(NSTimeInterval)timeout stabilizationTime:(NSTimeInterval)stabilizationTime {
    [self waitForAnimationsToFinishWithTimeout:timeout stabilizationTime:stabilizationTime mainThreadDispatchStabilizationTime:self.mainThreadDispatchStabilizationTimeout];
}

- (void)waitForAnimationsToFinishWithTimeout:(NSTimeInterval)timeout stabilizationTime:(NSTimeInterval)stabilizationTime mainThreadDispatchStabilizationTime:(NSTimeInterval)mainThreadDispatchStabilizationTime {
    NSTimeInterval maximumWaitingTimeInterval = timeout;
    if (maximumWaitingTimeInterval <= stabilizationTime) {
        if(maximumWaitingTimeInterval >= 0) {
            [self waitForTimeInterval:maximumWaitingTimeInterval relativeToAnimationSpeed:YES];
        }
    } else {
        
        // Wait for the view to stabilize and give them a chance to start animations before we wait for them.
        [self waitForTimeInterval:stabilizationTime relativeToAnimationSpeed:YES];
        maximumWaitingTimeInterval -= stabilizationTime;
        
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        [self runBlock:^KIFTestStepResult(NSError **error) {
            __block BOOL runningAnimationFound = false;
            for (UIWindow *window in [UIApplication sharedApplication].windowsWithKeyWindow) {
                [window performBlockOnDescendentViews:^(UIView *view, BOOL *stop) {
                    BOOL isViewVisible = [view isVisibleInViewHierarchy];   // do not wait for animations of views that aren't visible
                    BOOL hasUnfinishedSystemAnimation = [NSStringFromClass(view.class) isEqualToString:@"_UIParallaxDimmingView"];  // indicates that the view-hierarchy is in an in-between-state of an animation
                    if (isViewVisible && ([view.layer hasAnimations] || hasUnfinishedSystemAnimation)) {
                        runningAnimationFound = YES;
                        if (stop != NULL) {
                            *stop = YES;
                        }
                        return;
                    }
                }];
            }
            
            if (runningAnimationFound) {
                BOOL hasTimeRemainingToWait = ([NSDate timeIntervalSinceReferenceDate] - startTime) < maximumWaitingTimeInterval;
                if (hasTimeRemainingToWait) {
                    return KIFTestStepResultWait;
                } else {
                    // Animations appear to still exist, but we've hit our time limit
                    return KIFTestStepResultSuccess;
                }
            }
            
            return KIFTestStepResultSuccess;
        } timeout:maximumWaitingTimeInterval + 1];
    }
    
    /*
     *  On very rare occasions, a race condition can occur where a touch event enqueued on the main queue runloop will
     *  execute before the UI element it's intended to tap has appeared onscreen. KIF can then potentially send UI tap
     *  events to a view while it's still in the process of animating.
     *  By enqueuing a task on the main thread and spinning a runloop until its execution before the end of
     *  waitForAnimationsToFinishWithTimeout, we should be able to avoid this race condition.
     */
    
    if(mainThreadDispatchStabilizationTime > 0) {
        __block BOOL waitForRunloopTaskToProcess = NO;
        
        NSTimeInterval startOfMainDispatchQueueStabilization = [NSDate timeIntervalSinceReferenceDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            waitForRunloopTaskToProcess = YES;
        });
        
        [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
            NSTimeInterval elapsedTime = [NSDate timeIntervalSinceReferenceDate] - startOfMainDispatchQueueStabilization;
            if(!waitForRunloopTaskToProcess) {
                if(elapsedTime < mainThreadDispatchStabilizationTime) {
                    return KIFTestStepResultWait;
                } else {
                    // The main thread is still blocked, but we've hit our time limit
                    NSLog(@"WARN: Main thread still blocked while waiting %fs after animations completed!", mainThreadDispatchStabilizationTime);
                    return KIFTestStepResultSuccess;
                }
            }
            
            if(elapsedTime > mainThreadDispatchStabilizationTime) {
                NSLog(@"WARN: Main thread was blocked for more than %fs after animations completed!", stabilizationTime);
            }
            
            return KIFTestStepResultSuccess;
        } timeout:mainThreadDispatchStabilizationTime + 1];
    }
}
#pragma mark Typist Waiting

- (void)waitForKeyboard
{
    [self waitForSoftwareKeyboard];
}

- (void)waitForAbsenceOfKeyboard
{
    [self waitForAbsenceOfSoftwareKeyboard];
}

- (void)waitForSoftwareKeyboard;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition(![KIFTypist keyboardHidden], error, @"Keyboard is not visible");
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForAbsenceOfSoftwareKeyboard
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition([KIFTypist keyboardHidden], error, @"Keyboard is visible");
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForKeyInputReady
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition(![KIFTypist keyboardHidden] || [KIFTypist hasHardwareKeyboard], error, @"No software or hardware keyboard.");
        KIFTestWaitCondition([KIFTypist hasKeyInputResponder], error, @"No responder for key inputs.");
        
        return KIFTestStepResultSuccess;
    }];
}

#pragma mark - Conditionals

- (BOOL)tryFindingView;
{
    return ([self predicateSearchWithRequiresMatch:NO mustBeTappable:NO] != nil);
}

- (BOOL)tryFindingTappableView;
{
    return ([self predicateSearchWithRequiresMatch:NO mustBeTappable:YES] != nil);
}

- (BOOL)tryFindingAccessibilityElement:(out UIAccessibilityElement * __autoreleasing *)element view:(out UIView * __autoreleasing *)view withElementMatchingPredicate:(NSPredicate *)predicate tappable:(BOOL)mustBeTappable error:(out NSError **)error
{
    return [self tryRunningBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withElementMatchingPredicate:predicate tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
    } complete:nil timeout:1.0 error:error];
}

#pragma mark - Tap Actions

- (void)tap;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
        [self tapAccessibilityElement:found.element inView:found.view];
    }
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
            if (view != window && view != nil) {
                break;
            }
        }

        KIFTestWaitCondition(view, error, @"No view was found at the point %@", NSStringFromCGPoint(screenPoint));

        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        CGPoint viewPoint = [view convertPoint:screenPoint fromView:nil];
        [view tapAtPoint:viewPoint];

        return KIFTestStepResultSuccess;
    }];
}

- (void)tapAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)view
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        KIFTestWaitCondition(view.isUserInteractionActuallyEnabled, error, @"View is not enabled for interaction: %@", view);
        
        CGPoint tappablePointInElement = [self tappablePointInElement:element andView:view];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestWaitCondition(!isnan(tappablePointInElement.x), error, @"View is not tappable: %@", view);
        
        NSOperatingSystemVersion iOS9 = {9, 0, 0};
        BOOL isOperatingSystemAtLeastVersion9 = [NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS9];
        if (isOperatingSystemAtLeastVersion9 && [NSStringFromClass([view class]) isEqualToString:@"_UIAlertControllerActionView"]) {
            [view longPressAtPoint:tappablePointInElement duration:0.1];
        } else {
            [view tapAtPoint:tappablePointInElement];
        }
        
        return KIFTestStepResultSuccess;
    }];
    
    // Controls might not synchronously become first-responders. Sometimes custom controls
    // may need to spin the runloop before reporting as the first responder.
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFTestWaitCondition(![view canBecomeFirstResponder] || [view isDescendantOfFirstResponder], error, @"Failed to make the view into the first responder: %@", view);
        return KIFTestStepResultSuccess;
    } timeout:0.5];
    
    [self waitForAnimationsToFinish];
}

#pragma Mark - Long Press Actions

- (void)longPress;
{
    [self longPressWithDuration:.5];
}

- (void)longPressWithDuration:(NSTimeInterval)duration;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
        [self longPressAccessibilityElement:found.element inView:found.view duration:duration];
    }
}

- (void)longPressAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)view duration:(NSTimeInterval)duration;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        KIFTestWaitCondition(view.isUserInteractionActuallyEnabled, error, @"View is not enabled for interaction: %@", view);
        
        CGPoint tappablePointInElement = [self tappablePointInElement:element andView:view];
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestWaitCondition(!isnan(tappablePointInElement.x), error, @"View is not tappable: %@", view);
        [view longPressAtPoint:tappablePointInElement duration:duration];
        
        KIFTestCondition(![view canBecomeFirstResponder] || [view isDescendantOfFirstResponder], error, @"Failed to make the view into the first responder: %@", view);
        
        return KIFTestStepResultSuccess;
    }];
    
    // Wait for view to settle.
    [self waitForTimeInterval:0.5 relativeToAnimationSpeed:YES];
}


#pragma mark - Text Actions;

- (void)clearText;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self clearTextFromElement:found.element inView:found.view];
    }
}

- (void)enterText:(NSString *)text;
{
    [self enterText:text expectedResult:nil];
}

- (void)enterText:(NSString *)text expectedResult:(NSString *)expectedResult;
{
    if (!self.validateEnteredText && expectedResult) {
        [self failWithMessage:@"Can't supply an expectedResult string if `validateEnteredText` is NO."];
    }

    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self enterText:text intoElement:found.element inView:found.view expectedResult:expectedResult];
    }
}

- (void)clearAndEnterText:(NSString *)text;
{
    [self clearAndEnterText:text expectedResult:nil];
}

- (void)clearAndEnterText:(NSString *)text expectedResult:(NSString *)expectedResult;
{
    [self clearText];
    [self enterText:text expectedResult:expectedResult];
}

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text
{
    [self waitForKeyInputReady];
    [self enterTextIntoCurrentFirstResponder:text fallbackView:nil];
}

- (void)setText:(NSString *)text;
{
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        if (!found.view) {
            return KIFTestStepResultWait;
        }

        if (![found.view respondsToSelector:@selector(setText:)]) {
            return KIFTestStepResultFailure;
        }

        [found.view performSelector:@selector(setText:) withObject:text];
        return KIFTestStepResultSuccess;
    }];
}

- (NSString *)textFromView:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        return label.text ? : @"";
    } else if ([view isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)view;
        return [textField.text isEqual: @""] ? textField.placeholder : textField.text;
    } else if ([view isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)view;
        return textView.text;
    }
    return @"";
}

- (void)expectToContainText:(NSString *)expectedResult;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self expectView:found.view toContainText:expectedResult];
    }
}

- (void)clearTextFromFirstResponder
{
    @autoreleasepool {
        UIView *firstResponder = (id)[[[UIApplication sharedApplication] keyWindow] firstResponder];
        if ([firstResponder isKindOfClass:[UIView class]]) {
            [self clearTextFromElement:(UIAccessibilityElement *)firstResponder inView:firstResponder];
        }
    }
}
- (void)clearTextFromAndThenEnterTextIntoCurrentFirstResponder:(NSString *)text
{
    [[self usingFirstResponder] clearText];
    [[self usingFirstResponder] enterText:text];
}

- (void)clearTextFromElement:(UIAccessibilityElement *)element inView:(UIView *)view
{
    [self tapAccessibilityElement:element inView:view];
    
    // Per issue #294, the tap occurs in the center of the text view.  If the text is too long, this means not all text gets cleared.  To address this for most cases, we can check if the selected view conforms to UITextInput and select the whole text range.
    if ([view conformsToProtocol:@protocol(UITextInput)]) {
        id<UITextInput> textInput = (id<UITextInput>)view;
        [textInput setSelectedTextRange:[textInput textRangeFromPosition:textInput.beginningOfDocument toPosition:textInput.endOfDocument]];
        
        [self waitForTimeInterval:0.1 relativeToAnimationSpeed:YES];
        [self enterTextIntoCurrentFirstResponder:@"\b" fallbackView:view];
    } else {
        NSUInteger numberOfCharacters = [view respondsToSelector:@selector(text)] ? [(UITextField *)view text].length : element.accessibilityValue.length;
        NSMutableString *text = [NSMutableString string];
        for (NSInteger i = 0; i < numberOfCharacters; i ++) {
            [text appendString:@"\b"];
        }
        [self enterTextIntoCurrentFirstResponder:text fallbackView:view];
    }
    
    [self expectView:view toContainText:@""];
}

- (void)enterText:(NSString *)text intoElement:(UIAccessibilityElement *)element inView:(UIView *)view expectedResult:(NSString *)expectedResult;
{
    // In iOS7, tapping a field that is already first responder moves the cursor to the front of the field
    if (view.window.firstResponder != view) {
        [self tapAccessibilityElement:element inView:view];
        [self waitForTimeInterval:0.25 relativeToAnimationSpeed:YES];
    }
    
    [self enterTextIntoCurrentFirstResponder:text fallbackView:view];
    if (self.validateEnteredText) {
        [self expectView:view toContainText:expectedResult ?: text];
    }
}

- (void)expectView:(UIView *)view toContainText:(NSString *)expectedResult
{
    // We will perform some additional validation if the view is UITextField or UITextView.
    if (![view respondsToSelector:@selector(text)]) {
        return;
    }
    
    UITextView *textView = (UITextView *)view;
    
    // Some slower machines take longer for typing to catch up, so wait for a bit before failing
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // We trim \n and \r because they trigger the return key, so they won't show up in the final product on single-line inputs.
        // Also trim \b (backspace) characters to allow for deletion.
        NSMutableCharacterSet *charExclusionSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"\b"];
        [charExclusionSet formUnionWithCharacterSet:[NSCharacterSet newlineCharacterSet]];
        NSString *expected = [expectedResult stringByTrimmingCharactersInSet:charExclusionSet];
        NSString *actual = [textView.text stringByTrimmingCharactersInSet:charExclusionSet];
        
        KIFTestWaitCondition([actual isEqualToString:expected], error, @"Failed to get text \"%@\" in field; instead, it was \"%@\"", expected, actual);
        
        return KIFTestStepResultSuccess;
    } timeout:[KIFTestActor defaultTimeout]];
}

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text fallbackView:(UIView *)fallbackView
{
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString *characterString,NSRange substringRange,NSRange enclosingRange,BOOL * stop)
     {
         if (![KIFTypist enterCharacter:characterString]) {
             // Attempt to cheat if we couldn't find the character
             UIView * fallback = fallbackView;
             if (!fallback) {
                 UIResponder *firstResponder = [[[UIApplication sharedApplication] keyWindow] firstResponder];
                 
                 if ([firstResponder isKindOfClass:[UIView class]]) {
                     fallback = (UIView *)firstResponder;
                 }
             }
             
             if ([fallback isKindOfClass:[UITextField class]] || [fallback isKindOfClass:[UITextView class]] || [fallback isKindOfClass:[UISearchBar class]]) {
                 NSLog(@"KIF: Unable to find keyboard key for %@. Inserting manually.", characterString);
                 [(UITextField *)fallback setText:[[(UITextField *)fallback text] stringByAppendingString:characterString]];
             } else {
                 [self failWithError:[NSError KIFErrorWithFormat:@"Failed to find key for character \"%@\"", characterString] stopTest:YES];
             }
         }
     }];
    
    NSTimeInterval remainingWaitTime = 0.01 - [KIFTypist keystrokeDelay];
    if (remainingWaitTime > 0) {
        CFRunLoopRunInMode(UIApplicationCurrentRunMode, remainingWaitTime, false);
    }
}


#pragma mark - Touch Actions

- (void)swipeInDirection:(KIFSwipeDirection)direction;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self swipeAccessibilityElement:found.element inView:found.view inDirection:direction];
    }
}

- (void)swipeAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)viewToSwipe inDirection:(KIFSwipeDirection)direction
{
    // The original version of this came from http://groups.google.com/group/kif-framework/browse_thread/thread/df3f47eff9f5ac8c
    
    const NSUInteger kNumberOfPointsInSwipePath = 20;
    
    // Within this method, all geometry is done in the coordinate system of the view to swipe.
    CGRect elementFrame = [self elementFrameForElement:element andView:viewToSwipe];
    
    CGPoint swipeStart = CGPointCenteredInRect(elementFrame);
    
    KIFDisplacement swipeDisplacement = [self _displacementForSwipingInDirection:direction];
    
    [viewToSwipe dragFromPoint:swipeStart displacement:swipeDisplacement steps:kNumberOfPointsInSwipePath];
}

#pragma mark - ScrollView Actions

- (void)scrollByFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self scrollAccessibilityElement:found.element inView:found.view byFractionOfSizeHorizontal:horizontalFraction vertical:verticalFraction];
    }
}

- (void)scrollAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)viewToScroll byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction
{
    const NSUInteger kNumberOfPointsInScrollPath = 5;
    
    // Within this method, all geometry is done in the coordinate system of the view to scroll.
    CGRect elementFrame = [self elementFrameForElement:element andView:viewToScroll];
    
    KIFDisplacement scrollDisplacement = CGPointMake(elementFrame.size.width * horizontalFraction, elementFrame.size.height * verticalFraction);
    
    CGPoint scrollStart = CGPointCenteredInRect(elementFrame);
    scrollStart.x -= scrollDisplacement.x / 2;
    scrollStart.y -= scrollDisplacement.y / 2;
    
    [viewToScroll dragFromPoint:scrollStart displacement:scrollDisplacement steps:kNumberOfPointsInScrollPath];
}

#pragma mark - TableView Actions

- (void)tapRowInTableViewAtIndexPath:(NSIndexPath *)indexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UITableView class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self tapRowAtIndexPath:indexPath inTableView:(UITableView *)found.view];
    }
}

- (UITableViewCell *)waitForCellInTableViewAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self waitForCellInTableViewAtIndexPath:indexPath atPosition:UITableViewScrollPositionMiddle];
}

- (UITableViewCell *)waitForCellInTableViewAtIndexPath:(NSIndexPath *)indexPath atPosition:(UITableViewScrollPosition)position;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UITableView class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        return [self waitForCellAtIndexPath:indexPath inTableView:(UITableView *)found.view atPosition:position];
    }
}

- (void)moveRowInTableViewAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UITableView class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath inTableView:(UITableView *)found.view];
    }
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath inTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [self waitForCellAtIndexPath:sourceIndexPath inTableView:tableView];
    
    NSError *error = nil;
    if (![tableView dragCell:cell toIndexPath:destinationIndexPath error:&error]) {
        [self failWithError:error stopTest:YES];
    }
}

- (UITableViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
   return [self waitForCellAtIndexPath:indexPath inTableView:tableView atPosition:UITableViewScrollPositionMiddle];
}

- (UITableViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView atPosition:(UITableViewScrollPosition)position
{
    if (![tableView isKindOfClass:[UITableView class]]) {
        [self failWithError:[NSError KIFErrorWithFormat:@"View is not a table view"] stopTest:YES];
    }
    
    // If section < 0, search from the end of the table.
    if (indexPath.section < 0) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:tableView.numberOfSections + indexPath.section];
    }
    
    // If row < 0, search from the end of the section.
    if (indexPath.row < 0) {
        indexPath = [NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:indexPath.section] + indexPath.row inSection:indexPath.section];
    }
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        KIFTestWaitCondition(indexPath.section < tableView.numberOfSections, error, @"Section %ld is not found in table view", (long)indexPath.section);
        
        KIFTestWaitCondition(indexPath.row < [tableView numberOfRowsInSection:indexPath.section], error, @"Row %ld is not found in section %ld of table view", (long)indexPath.row, (long)indexPath.section);
        
        return KIFTestStepResultSuccess;
    }];
    
    __block UITableViewCell *cell = nil;
    __block CGFloat lastYOffset = CGFLOAT_MAX;
    [self runBlock:^KIFTestStepResult(NSError **error) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:[[self class] testActorAnimationsEnabled]];
        cell = [tableView cellForRowAtIndexPath:indexPath];
        KIFTestWaitCondition(!!cell, error, @"Table view cell at index path %@ not found", indexPath);
        
        if (lastYOffset != tableView.contentOffset.y) {
            lastYOffset = tableView.contentOffset.y;
            KIFTestWaitCondition(NO, error, @"Didn't finish scrolling to cell.");
        }
        
        return KIFTestStepResultSuccess;
    }];
    
    [self waitForTimeInterval:0.1 relativeToAnimationSpeed:YES]; // Let things settle.
    
    
    return cell;
}

- (void)tapRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [self waitForCellAtIndexPath:indexPath inTableView:tableView];
    CGRect cellFrame = [cell.contentView convertRect:cell.contentView.frame toView:tableView];
    [tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];
    
    [self waitForAnimationsToFinish];
}

- (void)swipeRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView inDirection:(KIFSwipeDirection)direction
{
    const NSUInteger kNumberOfPointsInSwipePath = 20;
    
    UITableViewCell *cell = [self waitForCellAtIndexPath:indexPath inTableView:tableView];
    CGRect cellFrame = [cell.contentView convertRect:cell.contentView.frame toView:tableView];
    CGPoint swipeStart = CGPointCenteredInRect(cellFrame);
    KIFDisplacement swipeDisplacement = [self _displacementForSwipingInDirection:direction];
    [tableView dragFromPoint:swipeStart displacement:swipeDisplacement steps:kNumberOfPointsInSwipePath];
    
    // Wait for the view to stabilize.
    [tester waitForTimeInterval:0.5 relativeToAnimationSpeed:YES];
    
}

- (void)waitForDeleteStateForCellAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*)tableView {
    UITableViewCell *cell = [self waitForCellAtIndexPath:indexPath inTableView:tableView];
    [self waitForDeleteStateForCell:cell];
}

- (void)waitForDeleteStateForCell:(UITableViewCell*)cell {
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition(cell.showingDeleteConfirmation, error,
                             @"Expected cell to get in the delete confirmation state: %@", cell);
        return KIFTestStepResultSuccess;
    }];
}

#pragma mark - CollectionView Actions

- (void)tapCollectionViewItemAtIndexPath:(NSIndexPath *)indexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UICollectionView class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self tapItemAtIndexPath:indexPath inCollectionView:(UICollectionView *)found.view];
    }
}

- (UICollectionViewCell *)waitForCellInCollectionViewAtIndexPath:(NSIndexPath *)indexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UICollectionView class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        return [self waitForCellAtIndexPath:indexPath inCollectionView:(UICollectionView *)found.view];
    }
}

- (void)tapItemAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView
{
    UICollectionViewCell *cell;
    cell = [self waitForCellAtIndexPath:indexPath inCollectionView:collectionView];
    
    CGRect cellFrame = [cell.contentView convertRect:cell.contentView.frame toView:collectionView];
    [collectionView tapAtPoint:CGPointCenteredInRect(cellFrame)];
    
    [self waitForAnimationsToFinish];
}

- (UICollectionViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView
{
    if (![collectionView isKindOfClass:[UICollectionView class]]) {
        [self failWithError:[NSError KIFErrorWithFormat:@"View is not a collection view"] stopTest:YES];
    }
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    // If section < 0, search from the end of the table.
    if (section < 0) {
        section += collectionView.numberOfSections;
    }
    
    // If item < 0, search from the end of the section.
    if (item < 0) {
        item += [collectionView numberOfItemsInSection:section];
    }
    
    indexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        KIFTestWaitCondition(indexPath.section < collectionView.numberOfSections, error, @"Section %ld is not found in collection view", (long)indexPath.section);
        
        KIFTestWaitCondition(indexPath.row < [collectionView numberOfItemsInSection:indexPath.section], error, @"Item %ld is not found in section %ld of collection view", (long)indexPath.row, (long)indexPath.section);
        
        return KIFTestStepResultSuccess;
    }];
    
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically
                                   animated:[[self class] testActorAnimationsEnabled]];
    
    // waitForAnimationsToFinish doesn't allow collection view to settle when animations are sped up
    // So use waitForTimeInterval instead
    const NSTimeInterval animationWaitTime = 0.5f;
    [self waitForTimeInterval:animationWaitTime relativeToAnimationSpeed:YES];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //For big collection views with many cells the cell might not be ready yet. Relayout and try again.
    if(cell == nil) {
        [collectionView layoutIfNeeded];
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically
                                       animated:NO];
        // waitForAnimationsToFinish doesn't allow collection view to settle when animations are sped up
        [self waitForTimeInterval:animationWaitTime relativeToAnimationSpeed:YES];
        cell = [collectionView cellForItemAtIndexPath:indexPath];
    }
    
    if (!cell) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Collection view cell at index path %@ not found", indexPath] stopTest:YES];
    }
    
    return cell;
}



#pragma mark - UIControl Actions

- (void)setSliderValue:(float)value;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UISlider class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self setValue:value forSlider:(UISlider *)found.view];
    }
}

- (void)setValue:(float)value forSlider:(UISlider *)slider
{
    if (value < slider.minimumValue) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Cannot slide past minimum value of %f", slider.minimumValue] stopTest:YES];
    }
    
    if (value > slider.maximumValue) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Cannot slide past maximum value of %f", slider.maximumValue] stopTest:YES];
    }
    
    CGRect trackRect = [slider trackRectForBounds:slider.bounds];
    CGPoint currentPosition = CGPointCenteredInRect([slider thumbRectForBounds:slider.bounds trackRect:trackRect value:slider.value]);
    CGPoint finalPosition = CGPointCenteredInRect([slider thumbRectForBounds:slider.bounds trackRect:trackRect value:value]);
    
    if (value == slider.minimumValue) {
        finalPosition.x = 0;
    } else if (value == slider.maximumValue) {
        finalPosition.x = slider.bounds.size.width;
    }
    
    [slider dragFromPoint:currentPosition toPoint:finalPosition steps:10];
}

- (void)setSwitchOn:(BOOL)switchIsOn;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UISwitch class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self setSwitch:(UISwitch *)found.view element:found.element On:switchIsOn];
    }
}

- (void)setSwitch:(UISwitch *)switchView element:(UIAccessibilityElement *)element On:(BOOL)switchIsOn
{
    // No need to switch it if it's already in the correct position
    if (switchView.isOn == switchIsOn) {
        return;
    }
    
    [self tapAccessibilityElement:element inView:switchView];
    
    // If we succeeded, stop the test.
    if (switchView.isOn == switchIsOn) {
        return;
    }
    
    NSLog(@"Faking turning switch %@", switchIsOn ? @"ON" : @"OFF");
    [switchView setOn:switchIsOn animated:[[self class] testActorAnimationsEnabled]];
    [switchView sendActionsForControlEvents:UIControlEventValueChanged];
    [self waitForTimeInterval:0.5 relativeToAnimationSpeed:YES];
    
    // We gave it our best shot.  Fail the test.
    if (switchView.isOn != switchIsOn) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Failed to toggle switch to \"%@\"; instead, it was \"%@\"", switchIsOn ? @"ON" : @"OFF", switchView.on ? @"ON" : @"OFF"] stopTest:YES];
    }
}

- (void)tapStepperToIncrement: (KIFStepperDirection) stepperDirection
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UIStepper class]] predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self tapStepperWithAccessibilityElement:found.element increment:stepperDirection inView:found.view];
    }
}

- (void)tapStepperWithAccessibilityElement:(UIAccessibilityElement *)element increment: (KIFStepperDirection) stepperDirection inView:(UIView *)view
{
    //inspired by http://www.raywenderlich.com/61419/ios-ui-testing-with-kif
    
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        KIFTestWaitCondition(view.isUserInteractionActuallyEnabled, error, @"View is not enabled for interaction: %@", view);
        
        CGPoint stepperPointToTap = [self tappablePointInElement:element andView:view];
        
        switch (stepperDirection)
        {
            case KIFStepperDirectionIncrement:
                stepperPointToTap.x += CGRectGetWidth(view.frame) / 4;
                break;
            case KIFStepperDirectionDecrement:
                stepperPointToTap.x -= CGRectGetWidth(view.frame) / 4;
                break;
        }
        
        // This is mostly redundant of the test in _accessibilityElementWithLabel:
        KIFTestWaitCondition(!isnan(stepperPointToTap.x), error, @"View is not tappable: %@", view);
        [view tapAtPoint:stepperPointToTap];
        
        KIFTestCondition(![view canBecomeFirstResponder] || [view isDescendantOfFirstResponder], error, @"Failed to make the view into the first responder: %@", view);
        
        return KIFTestStepResultSuccess;
    }];
    
    [self waitForAnimationsToFinish];
}

#pragma mark - Picker Actions

- (void)selectPickerViewRowWithTitle:(NSString *)title;
{
    [self selectPickerViewRowWithTitle:title inComponent:0];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component;
{
    [self selectPickerViewRowWithTitle:title inComponent:component withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component withSearchOrder:(KIFPickerSearchOrder)searchOrder
{
    [self selectPickerViewRowWithTitle:title inComponent:component fromPicker:nil withSearchOrder:searchOrder];
}

- (void)selectDatePickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component
{
    [self selectDatePickerViewRowWithTitle:title inComponent:component withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectDatePickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component withSearchOrder:(KIFPickerSearchOrder)searchOrder;
{
    [self selectPickerViewRowWithTitle:title inComponent:component fromPicker:nil withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues;
{
    [self selectDatePickerValue:datePickerColumnValues withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues withSearchOrder:(KIFPickerSearchOrder)searchOrder;
{
    [self selectDatePickerValue:datePickerColumnValues fromPicker:nil withSearchOrder:searchOrder];
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues fromPicker:(UIPickerView *)picker withSearchOrder:(KIFPickerSearchOrder)searchOrder
{
    [self selectPickerValue:datePickerColumnValues fromPicker:picker pickerType:KIFUIDatePicker withSearchOrder:searchOrder];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component fromPicker:(UIPickerView *)picker withSearchOrder:(KIFPickerSearchOrder)searchOrder
{
    NSMutableArray *dataToSelect = [[NSMutableArray alloc] init];
    
    UIPickerView *pickerView = picker;
    KIFPickerType pickerType = 0;
    
    if (pickerView == nil) {
        // Find all pickers in view. Either UIDatePickerView or UIPickerView
        NSArray *datePickerViews = [[[UIApplication sharedApplication] datePickerWindow] subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"];
        NSArray *pickerViews = [[[UIApplication sharedApplication] pickerViewWindow] subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"];
        
        // Grab one picker and assume it is datePicker and then test our hypothesis later!
        pickerView = [datePickerViews lastObject];
        if ([pickerView respondsToSelector:@selector(setDate:animated:)]) {
            pickerType = KIFUIDatePicker;
        } else {
            pickerView = [pickerViews lastObject];
            pickerType = KIFUIPickerView;
        }
    } else {
        if ([pickerView respondsToSelector:@selector(setDate:animated:)]) {
            pickerType = KIFUIDatePicker;
        } else {
            pickerType = KIFUIPickerView;
        }
    }
    
    // Add title at component index and add empty strings for other.
    // This support legacy function re-use.
    for (int i = 0; i < pickerView.numberOfComponents; i++) {
        if (component == i) {
            [dataToSelect addObject:title];
        } else {
            NSInteger currentIndex = [pickerView selectedRowInComponent:i];
            NSString *rowTitle = nil;
            if ([pickerView.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                rowTitle = [pickerView.delegate pickerView:pickerView titleForRow:currentIndex forComponent:i];
            } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)]) {
                rowTitle = [[pickerView.delegate pickerView:pickerView attributedTitleForRow:currentIndex forComponent:i] string];
            } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
                // This delegate inserts views directly, so try to figure out what the title is by looking for a label
                UIView *rowView = [pickerView.delegate pickerView:pickerView viewForRow:currentIndex forComponent:i reusingView:nil];
                if ([rowView isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *) rowView;
                    rowTitle = label.text;
                } else {
                    NSArray *labels = [rowView subviewsWithClassNameOrSuperClassNamePrefix:@"UILabel"];
                    UILabel *label = (labels.count > 0 ? labels[0] : nil);
                    rowTitle = label.text;
                }
            }
            if (rowTitle) {
                [dataToSelect addObject: rowTitle];
            } else {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unknown picker type. Delegate responds neither to pickerView:titleForRow:forComponent: nor to pickerView:viewForRow:forComponent:reusingView:" userInfo:nil];
            }
        }
    }
    [self selectPickerValue:dataToSelect fromPicker:pickerView pickerType:pickerType withSearchOrder:searchOrder];
}

- (void)selectPickerValue:(NSArray *)pickerColumnValues fromPicker:(UIPickerView *)picker pickerType:(KIFPickerType)pickerType withSearchOrder:(KIFPickerSearchOrder)searchOrder
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        NSInteger columnCount = [pickerColumnValues count];
        NSMutableArray* found_values = [NSMutableArray arrayWithCapacity:columnCount];
        for (NSInteger componentIndex = 0; componentIndex < columnCount; componentIndex++) {
            [found_values addObject:[NSNumber numberWithBool:NO]];
        }
        // Find the picker view
        UIPickerView *pickerView = picker;
        if (pickerView == nil) {
            switch (pickerType)
            {
                case KIFUIDatePicker:
                {
                    pickerView = [[[[UIApplication sharedApplication] datePickerWindow] subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"] lastObject];
                    KIFTestCondition(pickerView, error, @"No picker view is present");
                    break;
                }
                case KIFUIPickerView:
                {
                    pickerView = [[[[UIApplication sharedApplication] pickerViewWindow] subviewsWithClassNameOrSuperClassNamePrefix:@"UIPickerView"] lastObject];
                }
            }
        }
        
        NSInteger componentCount = [pickerView.dataSource numberOfComponentsInPickerView:pickerView];
        KIFTestCondition(componentCount == columnCount, error, @"The Picker does not have the expected column count.");
        
        for (NSInteger componentIndex = 0; componentIndex < componentCount; componentIndex++) {
            
            // Set search order
            NSInteger firstIndex;
            NSInteger rowCount = [pickerView.dataSource pickerView:pickerView numberOfRowsInComponent:componentIndex];
            NSInteger indexProgress = (searchOrder == KIFPickerSearchBackwardFromCurrentValue ||
                                       searchOrder == KIFPickerSearchBackwardFromEnd) ? -1 : 1;
            switch (searchOrder) {
                case KIFPickerSearchForwardFromCurrentValue:
                case KIFPickerSearchBackwardFromCurrentValue:
                    firstIndex = [pickerView selectedRowInComponent:componentIndex];
                    break;
                case KIFPickerSearchBackwardFromEnd:
                    firstIndex = rowCount - 1;
                    break;
                default:
                    firstIndex = 0;
                    break;
            }
            
            //Fix issue with AM:PM
            if (rowCount == 2) { indexProgress = 1; firstIndex = 0; }
            
            for (NSInteger rowIndex = firstIndex; rowIndex < rowCount && rowIndex >= 0; rowIndex += indexProgress) {
                NSString *rowTitle = nil;
                if ([pickerView.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                    rowTitle = [pickerView.delegate pickerView:pickerView titleForRow:rowIndex forComponent:componentIndex];
                } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)]) {
                    rowTitle = [[pickerView.delegate pickerView:pickerView attributedTitleForRow:rowIndex forComponent:componentIndex] string];
                } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
                    
                    UIView *rowView = [pickerView.delegate pickerView:pickerView viewForRow:rowIndex forComponent:componentIndex reusingView:nil];
                    UILabel *label;
                    if ([rowView isKindOfClass:[UILabel class]] ) {
                        label = (id)rowView;
                    } else {
                        // This delegate inserts views directly, so try to figure out what the title is by looking for a label
                        NSArray *labels = [rowView subviewsWithClassNameOrSuperClassNamePrefix:@"UILabel"];
                        label = (labels.count > 0 ? labels[0] : nil);
                    }
                    rowTitle = label.text;
                }
                
                if (rowIndex==[pickerView selectedRowInComponent:componentIndex] && [rowTitle isEqual:pickerColumnValues[componentIndex]]){
                    [found_values replaceObjectAtIndex:componentIndex withObject:@(YES)];
                    break;
                }
                else if ([rowTitle isEqual:pickerColumnValues[componentIndex]]) {
                    [pickerView selectRow:rowIndex inComponent:componentIndex animated:NO];
                    KIFRunLoopRunInModeRelativeToAnimationSpeed(kCFRunLoopDefaultMode, 1.0f, NO);
                    // Even though selectRow says it's not animated - it really is. We need to wait for them to finish before continuing.
                    [tester waitForAnimationsToFinish];
                    
                    // Tap in the middle of the picker view to select the item
                    [pickerView tap];
                    [self waitForTimeInterval:0.5 relativeToAnimationSpeed:YES];
                    
                    // The combination of selectRow:inComponent:animated: and tap does not consistently result in
                    // pickerView:didSelectRow:inComponent: being called on the delegate. We need to do it explicitly.
                    if ([pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
                        [pickerView.delegate pickerView:pickerView didSelectRow:rowIndex inComponent:componentIndex];
                    }
                    
                    [found_values replaceObjectAtIndex:componentIndex withObject:@(YES)];
                    break;
                }
            }
            if (found_values[componentIndex] == [NSNumber numberWithBool:YES]) {
                continue;
            }
        }
        
        // Support multiple column by adding flag to check if the value found in
        // at-least one column
        BOOL _foundInOneColumn = NO;
        for (NSInteger componentIndex = 0; componentIndex < columnCount; componentIndex++) {
            if (found_values[componentIndex] != [NSNumber numberWithBool:NO]) {
                _foundInOneColumn = YES;
            }
        }
        
        if (!_foundInOneColumn) {
            KIFTestCondition(NO, error, @"Failed to select from Picker.");
            return KIFTestStepResultFailure;
        }
        
        return KIFTestStepResultSuccess;
    }];
}

#pragma mark - Photo Picker

- (void)choosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column
{
    // This is basically the same as the step to tap with an accessibility label except that the accessibility labels for the albums have the number of photos appended to the end, such as "My Photos (3)." This means that we have to do a prefix match rather than an exact match.
    [self runBlock:^KIFTestStepResult(NSError **error) {
        
        NSString *labelPrefix = [NSString stringWithFormat:@"%@", albumName];
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementMatchingBlock:^(UIAccessibilityElement *element) {
            return [element.accessibilityLabel hasPrefix:labelPrefix];
        }];
        
        KIFTestWaitCondition(element, error, @"Failed to find photo album with name %@", albumName);
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Failed to find view for photo album with name %@", albumName);
        
        if (![view isUserInteractionActuallyEnabled]) {
            if (error) {
                *error = [NSError KIFErrorWithFormat:@"Album picker is not enabled for interaction"];
            }
            return KIFTestStepResultWait;
        }
        
        CGPoint tappablePointInElement = [self tappablePointInElement:element andView:view];
        [view tapAtPoint:tappablePointInElement];
        
        return KIFTestStepResultSuccess;
    }];
    
    // Wait for media picker view controller to be pushed.
    [self waitForTimeInterval:1 relativeToAnimationSpeed:YES];
    
    // Tap the desired photo in the grid
    // TODO: This currently only works for the first page of photos. It should scroll appropriately at some point.
    UIAccessibilityElement *headerElt = [[UIApplication sharedApplication] accessibilityElementMatchingBlock:^(UIAccessibilityElement *element) {
        return [NSStringFromClass(element.class) isEqual:@"UINavigationItemButtonView"];
    }];
    UIView* headerView = [UIAccessibilityElement viewContainingAccessibilityElement:headerElt];
    CGRect headerFrame = [headerView convertRect:headerView.frame toView:headerView.window];
    const CGFloat headerBottom =  headerFrame.origin.y + headerFrame.size.height;
    const CGSize thumbnailSize = CGSizeMake(75.0, 75.0);
    const CGFloat thumbnailMargin = 5.0;
    CGPoint thumbnailCenter;
    thumbnailCenter.x = thumbnailMargin + (MAX(0, column - 1) * (thumbnailSize.width + thumbnailMargin)) + thumbnailSize.width / 2.0;
    thumbnailCenter.y = headerBottom + thumbnailMargin + (MAX(0, row - 1) * (thumbnailSize.height + thumbnailMargin)) + thumbnailSize.height / 2.0;
    [self tapScreenAtPoint:thumbnailCenter];
}

#pragma mark - Pull to Refresh

- (void)pullToRefresh;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self pullToRefreshAccessibilityElement:found.element inView:found.view pullDownDuration:0];
    }
}

- (void)pullToRefreshWithDuration:(KIFPullToRefreshTiming)pullDownDuration;
{
    @autoreleasepool {
        KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self pullToRefreshAccessibilityElement:found.element inView:found.view pullDownDuration:pullDownDuration];
    }
}

- (void)pullToRefreshAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)viewToSwipe pullDownDuration:(KIFPullToRefreshTiming) pullDownDuration
{
    //Based on swipeAccessibilityElement
    
    const NSUInteger kNumberOfPointsInSwipePath = pullDownDuration ? pullDownDuration : KIFPullToRefreshInAboutAHalfSecond;
    
    // Can handle only the touchable space.
    CGRect elementFrame = [viewToSwipe convertRect:viewToSwipe.bounds toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    CGPoint swipeStart = CGPointCenteredInRect(elementFrame);
    CGPoint swipeDisplacement = CGPointMake(CGRectGetMidX(elementFrame), CGRectGetMaxY(elementFrame));
    
    [viewToSwipe dragFromPoint:swipeStart displacement:swipeDisplacement steps:kNumberOfPointsInSwipePath];
}

#pragma mark - Getters

- (UIView *)view;
{
    return [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO].view;
}

- (UIAccessibilityElement *)element;
{
    return [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO].element;
}

#pragma mark - NSObject

- (NSString *)description;
{
    KIFUIObject *found = [self predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
    return [NSString stringWithFormat:@"<%@; view=%@; element=%@; predicate=%@>", [super description], found.view, found.element, self.predicate];
}

#pragma mark - UIAccessibilityElement Helpers

- (CGRect)elementFrameForElement:(UIAccessibilityElement *)element andView:(UIView *)view
{
    CGRect elementFrame;
    
    // If the accessibilityFrame is not set, fallback to the view frame.
    if (CGRectEqualToRect(CGRectZero, element.accessibilityFrame)) {
        elementFrame.origin = CGPointZero;
        elementFrame.size = view.frame.size;
    } else {
        elementFrame = [view.windowOrIdentityWindow convertRect:element.accessibilityFrame toView:view];
    }
    return elementFrame;
}

- (CGPoint)tappablePointInElement:(UIAccessibilityElement *)element andView:(UIView *)view
{
    CGRect elementFrame = [self elementFrameForElement:element andView:view];
    CGPoint tappablePoint = [view tappablePointInRect:elementFrame];
    
    return tappablePoint;
}

#pragma mark - Class Methods

+ (BOOL)testActorAnimationsEnabled;
{
    return KIFUITestActorAnimationsEnabled;
}

+ (void)setTestActorAnimationsEnabled:(BOOL)animationsEnabled;
{
    KIFUITestActorAnimationsEnabled = animationsEnabled;
}

#pragma mark - Predicate

- (KIFUIObject *)predicateSearchWithRequiresMatch:(BOOL)requiresMatch mustBeTappable:(BOOL)tappable;
{
    __block UIView *foundView = nil;
    __block UIAccessibilityElement *foundElement = nil;
    
    if (requiresMatch) {
        [self waitForAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable];
    } else {
        NSError *error;
        [self tryRunningBlock:^KIFTestStepResult(NSError **error) {
            KIFTestWaitCondition([self tryFindingAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable error:error], error, @"Waiting on view matching %@", self.predicate.kifPredicateDescription);
            return KIFTestStepResultSuccess;
        } complete:nil timeout:1.0 error:&error];
    }
    
    if (foundView && foundElement) {
        return [[KIFUIObject alloc] initWithElement:foundElement view:foundView];
    }
    return nil;
}


#pragma mark - Private Methods

- (instancetype)_usingExpectedClass:(Class)expectedClass;
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:expectedClass];
    }];
    
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"is kind of Class \"%@\"", NSStringFromClass(expectedClass)];
    return [self usingPredicate:predicate];
}

- (void)_appendPredicate:(NSPredicate *)newPredicate;
{
    if (!self.predicate) {
        self.predicate = newPredicate;
    } else {
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ self.predicate, newPredicate ]];
        self.predicate = compoundPredicate;
    }
}

- (UIPickerView *)_getDatePickerViewFromPicker:(UIView *)picker;
{
    for (UIView *view in picker.subviews) {
        if ([NSStringFromClass([view class]) hasPrefix:@"_UIDatePickerView"]) {
            return (UIPickerView *) view;
        }
    }
    return nil;
}

- (KIFDisplacement)_displacementForSwipingInDirection:(KIFSwipeDirection)direction;
{
    switch (direction) {
            // As discovered on the Frank mailing lists, it won't register as a
            // swipe if you move purely horizontally or vertically, so need a
            // slight orthogonal offset too.
        case KIFSwipeDirectionRight:
            return CGPointMake(UIScreen.mainScreen.majorSwipeDisplacement, kKIFMinorSwipeDisplacement);
        case KIFSwipeDirectionLeft:
            return CGPointMake(-UIScreen.mainScreen.majorSwipeDisplacement, kKIFMinorSwipeDisplacement);
        case KIFSwipeDirectionUp:
            return CGPointMake(kKIFMinorSwipeDisplacement, -UIScreen.mainScreen.majorSwipeDisplacement);
        case KIFSwipeDirectionDown:
            return CGPointMake(kKIFMinorSwipeDisplacement, UIScreen.mainScreen.majorSwipeDisplacement);
    }
}

@end
