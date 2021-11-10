//
//  KIFTester+UI.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFUITestActor.h"

#import "CALayer-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "KIFSystemTestActor.h"
#import "KIFTestActor_Private.h"
#import "KIFTypist.h"
#import "NSError-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIAutomationHelper.h"
#import "UIScreen+KIFAdditions.h"
#import "UITableView-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"
#import "UIDatePicker+KIFAdditions.h"

#define kKIFMinorSwipeDisplacement 5


#if DEPRECATE_KIF_TESTER
KIFUITestActor *_KIF_tester()
{
    NSCAssert(NO, @"Attempting to use deprecated `KIFUITestActor`!");
    return nil;
}
#endif


@interface KIFUITestActor ()

@property (nonatomic, assign) BOOL validateEnteredText;

@end

static BOOL KIFUITestActorAnimationsEnabled = YES;

@implementation KIFUITestActor

+ (void)initialize
{
    if (self == [KIFUITestActor class]) {
        [KIFTypist registerForNotifications];
    }
}

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
{
    self = [super initWithFile:file line:line delegate:delegate];
    NSParameterAssert(self);
    _validateEnteredText = YES;
    return self;
}

- (instancetype)validateEnteredText:(BOOL)validateEnteredText;
{
    self.validateEnteredText = validateEnteredText;
    return self;
}

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label
{
    return [self waitForViewWithAccessibilityLabel:label value:nil traits:UIAccessibilityTraitNone tappable:NO];
}

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    return [self waitForViewWithAccessibilityLabel:label value:nil traits:traits tappable:NO];
}

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    return [self waitForViewWithAccessibilityLabel:label value:value traits:traits tappable:NO];
}

- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label
{
    return [self waitForViewWithAccessibilityLabel:label value:nil traits:UIAccessibilityTraitNone tappable:YES];
}

- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    return [self waitForViewWithAccessibilityLabel:label value:nil traits:traits tappable:YES];
}

- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    return [self waitForViewWithAccessibilityLabel:label value:value traits:traits tappable:YES];
}

- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable
{
    UIView *view = nil;
    @autoreleasepool
    {
        [self waitForAccessibilityElement:NULL view:&view withLabel:label value:value traits:traits tappable:mustBeTappable];
    }

    return view;
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement * __autoreleasing *)element view:(out UIView * __autoreleasing *)view withLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withLabel:label value:value traits:traits tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
    }];
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement * __autoreleasing *)element view:(out UIView * __autoreleasing *)view withLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits fromRootView:(UIView *)fromView tappable:(BOOL)mustBeTappable
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withLabel:label value:value traits:traits fromRootView:fromView tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
    }];
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement **)element view:(out UIView **)view withIdentifier:(NSString *)identifier tappable:(BOOL)mustBeTappable
{
    if (![UIAccessibilityElement instancesRespondToSelector:@selector(accessibilityIdentifier)]) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Running test on platform that does not support accessibilityIdentifier"] stopTest:YES];
    }

    [self waitForAccessibilityElement:element view:view withElementMatchingPredicate:[NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@", identifier] tappable:mustBeTappable];
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement *__autoreleasing *)element view:(out UIView *__autoreleasing *)view withIdentifier:(NSString *)identifier fromRootView:(UIView *)fromView tappable:(BOOL)mustBeTappable
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withElementMatchingPredicate:[NSPredicate predicateWithFormat:@"accessibilityIdentifier = %@", identifier] fromRootView:fromView tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
    }];
}

- (void)waitForAccessibilityElement:(UIAccessibilityElement * __autoreleasing *)element view:(out UIView * __autoreleasing *)view withElementMatchingPredicate:(NSPredicate *)predicate tappable:(BOOL)mustBeTappable
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withElementMatchingPredicate:predicate tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
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
        KIFTestWaitCondition([view isHidden] || [view superview] == nil, error, @"Accessibility element %@ with label \"%@\" is visible and not hidden.", view, label);
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForAbsenceOfViewWithElementMatchingPredicate:(NSPredicate *)predicate {
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // If the app is ignoring interaction events, then wait before doing our analysis
        KIFTestWaitCondition(![[UIApplication sharedApplication] isIgnoringInteractionEvents], error, @"Application is ignoring interaction events.");

        // If the element can't be found, then we're done
        UIAccessibilityElement *element = nil;
        if (![UIAccessibilityElement accessibilityElement:&element view:NULL withElementMatchingPredicate:predicate tappable:NO error:NULL]) {
            return KIFTestStepResultSuccess;
        }

        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];

        // If we found an element, but it's not associated with a view, then something's wrong. Wait it out and try again.
        KIFTestWaitCondition(view, error, @"Cannot find view containing accessibility element with the predicate \"%@\"", predicate);

        // Hidden views count as absent
        KIFTestWaitCondition([view isHidden] || [view superview] == nil, error, @"Accessibility element with predicate \"%@\" is visible and not hidden.", predicate);

        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForAnimationsToFinish {
    [self waitForAnimationsToFinishWithTimeout:self.animationWaitingTimeout];
}

- (void)waitForAnimationsToFinishWithTimeout:(NSTimeInterval)timeout {
    [self waitForAnimationsToFinishWithTimeout:timeout stabilizationTime:self.animationStabilizationTimeout];
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

- (void)tapViewWithAccessibilityLabel:(NSString *)label
{
    [self tapViewWithAccessibilityLabel:label value:nil traits:UIAccessibilityTraitNone];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self tapViewWithAccessibilityLabel:label value:nil traits:traits];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits
{
    @autoreleasepool
    {
        UIView *view = nil;
        UIAccessibilityElement *element = nil;
        [self waitForAccessibilityElement:&element view:&view withLabel:label value:value traits:traits tappable:YES];
        [self tapAccessibilityElement:element inView:view];
    }
}

- (void)tapAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)view
{
    BOOL wasAccessibilityElementOnscreen = ((id)element != view) && !CGRectEqualToRect([element accessibilityFrame], CGRectZero);

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

    [self waitForAnimationsToFinish];

    // Controls might not synchronously become first-responders. Sometimes custom controls
    // may need to spin the runloop before reporting as the first responder.
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        // When we're interacting with an accessibility element, it might go offscreen before we're able to do this check
        BOOL isAccessibilityElementOffscreen = ((id)element != view) && CGRectEqualToRect([element accessibilityFrame], CGRectZero);
        BOOL accessibilityElementDisappeared = wasAccessibilityElementOnscreen && isAccessibilityElementOffscreen;

        KIFTestWaitCondition(![view canBecomeFirstResponder] || ![view isProbablyTappable] || [view isDescendantOfFirstResponder] || accessibilityElementDisappeared, error, @"Failed to make the view into the first responder: %@", view);
        return KIFTestStepResultSuccess;
    } timeout:[KIFTestActor firstResponderTimeout]];
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

- (void)longPressViewWithAccessibilityLabel:(NSString *)label duration:(NSTimeInterval)duration;
{
    [self longPressViewWithAccessibilityLabel:label value:nil traits:UIAccessibilityTraitNone duration:duration];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value duration:(NSTimeInterval)duration;
{
    [self longPressViewWithAccessibilityLabel:label value:value traits:UIAccessibilityTraitNone duration:duration];
}

- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits duration:(NSTimeInterval)duration;
{
    @autoreleasepool
    {
        UIView *view = nil;
        UIAccessibilityElement *element = nil;
        [self waitForAccessibilityElement:&element view:&view withLabel:label value:value traits:traits tappable:YES];
        [self longPressAccessibilityElement:element inView:view duration:duration];
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

- (void)waitForKeyboard
{
    [self waitForSoftwareKeyboard];
}

- (void)waitForSoftwareKeyboard
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        KIFTestWaitCondition(![KIFTypist keyboardHidden], error, @"Keyboard is not visible");
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForAbsenceOfKeyboard
{
    [self waitForAbsenceOfSoftwareKeyboard];
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

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text
{
    [self waitForKeyInputReady];
    [self enterTextIntoCurrentFirstResponder:text fallbackView:nil];
}

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text fallbackView:(UIView *)fallbackView
{
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString *characterString,NSRange substringRange,NSRange enclosingRange,BOOL * stop)
     {
        if (![KIFTypist enterCharacter:characterString]) {
            NSLog(@"KIF: Unable to find keyboard key for %@. Will attempt to insert manually.", characterString);

            // Attempt to cheat if we couldn't find the character
            NSMutableArray *fallbackViews = [NSMutableArray array];

            if (fallbackView) {
                [fallbackViews addObject:fallbackView];
            } else {
                [fallbackViews addObjectsFromArray:[[UIApplication sharedApplication] firstResponders]];
            }
            
            for (id fallback in [fallbackViews copy]) {
                if (![fallback isKindOfClass:[UITextField class]] &&
                    ![fallback isKindOfClass:[UITextView class]] &&
                    ![fallback isKindOfClass:[UISearchBar class]]) {
                    [fallbackViews removeObject:fallback];
                }
            }

            UITextField *fallbackTextView = fallbackViews.firstObject;
            if (fallbackTextView) {
                if (fallbackViews.count > 1) {
                    NSLog(@"KIF: Found multiple possible fallback views for entering text: %@. Will use: %@", fallbackViews, fallbackTextView);
                }

                [fallbackTextView setText:[[fallbackTextView text] stringByAppendingString:characterString]];
                return;
            }

            [self failWithError:[NSError KIFErrorWithFormat:@"Failed to find key for character \"%@\"", characterString] stopTest:YES];
        }
    }];

    NSTimeInterval remainingWaitTime = 0.01 - [KIFTypist keystrokeDelay];
    if (remainingWaitTime > 0) {
        CFRunLoopRunInMode(UIApplicationCurrentRunMode, remainingWaitTime, false);
    }
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    return [self enterText:text intoViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone expectedResult:nil];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult
{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;

    [self waitForAccessibilityElement:&element view:&view withLabel:label value:nil traits:traits tappable:YES];

    [self enterText:text intoElement:element inView:view expectedResult:expectedResult];
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

- (void)clearTextFromFirstResponder
{
    @autoreleasepool {
        NSArray *firstResponders = [[UIApplication sharedApplication] firstResponders];

        for (UIResponder *firstResponder in firstResponders) {
            if ([firstResponder isKindOfClass:[UIView class]]) {
                if (firstResponders.count > 1) {
                    NSLog(@"KIF: Found multiple first responders while attempting to clear text: %@. Will use: %@.", firstResponders, firstResponder);
                }

                [self clearTextFromElement:(UIAccessibilityElement *)firstResponder inView:(UIView *)firstResponder];
                break;
            }
        }
    }
}

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label
{
    [self clearTextFromViewWithAccessibilityLabel:label traits:UIAccessibilityTraitNone];
}

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;

    [self waitForAccessibilityElement:&element view:&view withLabel:label value:nil traits:traits tappable:YES];
    [self clearTextFromElement:element inView:view];
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

- (void)clearTextFromAndThenEnterTextIntoCurrentFirstResponder:(NSString *)text
{
    [self clearTextFromFirstResponder];
    [self enterTextIntoCurrentFirstResponder:text];
}

- (void)setText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;

    [self waitForAccessibilityElement:&element view:&view withLabel:label value:nil traits:UIAccessibilityTraitNone tappable:YES];
    if ([view respondsToSelector:@selector(setText:)]) {
        [view performSelector:@selector(setText:) withObject:text];
    }
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

- (void)selectPickerViewRowWithTitle:(NSString *)title
{
    NSArray *dataToSelect = @[ title ];
    [self selectPickerValue:dataToSelect fromPicker:nil pickerType:KIFUIPickerView withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component
{
    [self selectPickerViewRowWithTitle:title inComponent:component fromPicker:nil withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component withSearchOrder:(KIFPickerSearchOrder)searchOrder
{
    [self selectPickerViewRowWithTitle:title inComponent:component fromPicker:nil withSearchOrder:searchOrder];
}

// date formatter to be used so we don't keep re-allocating a new one.
+ (NSDateFormatter *)__kifDateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *__kifDateFormatter = nil;
    dispatch_once(&onceToken, ^{
        __kifDateFormatter = [[NSDateFormatter alloc] init];
    });
    
    return __kifDateFormatter;
}

// uses the date pickers locale to find the ordering of day month and year.
+ (NSArray<NSString *>*)dateOrderForDatePicker:(UIDatePicker *)datePicker
{
    NSString *dateFormatString = [NSDateFormatter dateFormatFromTemplate:@"yMMMMd" options:0 locale:datePicker.locale];
    __block BOOL hasAddedYear = NO;
    __block BOOL hasAddedMonth = NO;
    __block BOOL hasAddedDay = NO;
    NSMutableArray *dateOrder = [NSMutableArray array];
    [dateFormatString enumerateSubstringsInRange:NSMakeRange(0, dateFormatString.length)
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if([substring containsString:@"y"] && !hasAddedYear) {
            hasAddedYear = YES;
            [dateOrder addObject:@"y"];
        }
        
        if([substring containsString:@"d"] && !hasAddedDay) {
            hasAddedDay = YES;
            [dateOrder addObject:@"d"];
        }
        
        if([substring containsString:@"M"] && !hasAddedMonth) {
            hasAddedMonth = YES;
            [dateOrder addObject:@"M"];
        }
    }];
    
    return [dateOrder copy];
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues
{
    [self selectDatePickerValue:datePickerColumnValues withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues withSearchOrder:(KIFPickerSearchOrder)searchOrder
{
    UIDatePicker *datePicker = [[[[UIApplication sharedApplication] datePickerWindow] subviewsWithClassNamePrefix:@"UIDatePicker"] firstObject];
    [self selectDatePickerValue:datePickerColumnValues fromPicker:datePicker withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues fromPicker:(UIDatePicker *)datePicker withSearchOrder:(KIFPickerSearchOrder)searchOrder
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.timeZone = datePicker.timeZone;
    NSArray *dateOrder = [self.class dateOrderForDatePicker:datePicker];
    
    // Backwards compatibility while migrating away from this deprecated API.
    if(datePicker.datePickerMode == UIDatePickerModeDate) {
        // using the date order from the current locale grab use the index that corresponds to the date unit (month, day, or year)
        // to grab the correct value from the provided array.
        for (int i = 0; i < datePickerColumnValues.count; i++) {
            if([dateOrder[i] isEqualToString:@"y"]) {
                dateComponents.year = [datePickerColumnValues[i] integerValue];
            } else if ([dateOrder[i] isEqualToString:@"M"]) {
                dateComponents.month = [self.class.__kifDateFormatter.monthSymbols containsObject:datePickerColumnValues[i]] ? [self.class.__kifDateFormatter.monthSymbols indexOfObject:datePickerColumnValues[i]] + 1 : NSNotFound ;
            } else if ([dateOrder[i] isEqualToString:@"d"]) {
                dateComponents.day = [datePickerColumnValues[i] integerValue];
            }
        }
    } else if (datePicker.datePickerMode == UIDatePickerModeTime) {
        dateComponents.minute = [datePickerColumnValues[1] integerValue];
        
        BOOL isPM = NO;
        if(datePickerColumnValues.count > 2 && [datePickerColumnValues.lastObject isEqualToString:self.class.__kifDateFormatter.PMSymbol]) {
            isPM = YES;
        }
        
        dateComponents.hour = isPM ? [datePickerColumnValues[0] integerValue] + 12 : [datePickerColumnValues[0] integerValue];
    } else if (datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        NSAssert(datePickerColumnValues.count == 3 || datePickerColumnValues.count == 4, @"Invalid datePickerColumnValue count. Expected 3 or 4 got %@", @(datePickerColumnValues.count));
        NSString *dayOfWeekMonthDay = datePickerColumnValues[0];
        // in a date time picker the first value is either "Today" or something like "Tue Aug 12" so seperate by a space to
        // grab the correct values from it.
        NSArray<NSString *>*dayOfWeekMonthDayComponents = [dayOfWeekMonthDay componentsSeparatedByString:@" "];
        NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:datePicker.date];
        // if the string components of the first value is 1 we assume it's saying "Today" and use the current dates components
        if(dayOfWeekMonthDayComponents.count == 1) {
            NSDateComponents *todayDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
            dateComponents = todayDateComponents;
        } else {
            for (NSString *component in dayOfWeekMonthDayComponents) {
                // check if the month and day of the component is found in the column and set the components respectively.
                if ([self.class.__kifDateFormatter.monthSymbols containsObject:component]) {
                    dateComponents.month = [self.class.__kifDateFormatter.monthSymbols indexOfObject:component] + 1;
                } else if ([self.class.__kifDateFormatter.shortMonthSymbols containsObject:component]) {
                    dateComponents.month = [self.class.__kifDateFormatter.shortMonthSymbols indexOfObject:component] + 1;
                } else if ([component integerValue] != 0) { // days can't be zero and if a string is not a number it will default to zero.
                    dateComponents.day = [component integerValue];
                }
            }
        }
    
        BOOL shouldOffsetPM = NO;
        if(datePickerColumnValues.count == 4 &&
           [datePickerColumnValues.lastObject isEqualToString:self.class.__kifDateFormatter.PMSymbol] &&
           [datePickerColumnValues[1] integerValue] != 12) { // If the time is 12pm, 12 shouldn't be added to make it 24h format
            shouldOffsetPM = YES;
        }
        
        dateComponents.hour = shouldOffsetPM ? [datePickerColumnValues[1] integerValue] + 12 : [datePickerColumnValues[1] integerValue];
        dateComponents.minute = [datePickerColumnValues[2] integerValue];
        dateComponents.year = currentDateComponents.year;
    }
    
    if (datePicker.datePickerMode != UIDatePickerModeCountDownTimer) {
        [datePicker selectDate:[[NSCalendar currentCalendar] dateFromComponents:dateComponents]];
    } else {
        NSAssert(datePickerColumnValues.count == 2, @"Invalid datePickerColumnValue count. Expect 2 got %@", @(datePickerColumnValues.count));
        [datePicker selectCountdownHours:[datePickerColumnValues[0] integerValue] minutes:[datePickerColumnValues[1] integerValue]];
    }
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component fromPicker:(UIPickerView *)picker
{
    [self selectPickerViewRowWithTitle:title inComponent:component fromPicker:picker withSearchOrder:KIFPickerSearchForwardFromStart];
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
        if ([pickerView respondsToSelector:@selector(setDate:animated:)] || [pickerView isKindOfClass:NSClassFromString(@"_UIDatePickerView")]) {
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

- (void)setOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label
{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;

    [self waitForAccessibilityElement:&element view:&view withLabel:label value:nil traits:UIAccessibilityTraitButton tappable:YES];

    if (![view isKindOfClass:[UISwitch class]]) {
        [self failWithError:[NSError KIFErrorWithFormat:@"View with accessibility label \"%@\" is a %@, not a UISwitch", label, NSStringFromClass([view class])] stopTest:YES];
    }
    UISwitch *switchView = (UISwitch *)view;

    [self setSwitch:switchView element:element On:switchIsOn];
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



- (void)setValue:(float)value forSliderWithAccessibilityLabel:(NSString *)label
{
    UISlider *slider = nil;
    UIAccessibilityElement *element = nil;
    [self waitForAccessibilityElement:&element view:&slider withLabel:label value:nil traits:UIAccessibilityTraitNone tappable:YES];

    if (![slider isKindOfClass:[UISlider class]]) {
        [self failWithError:[NSError KIFErrorWithFormat:@"View with accessibility label \"%@\" is a %@, not a UISlider", label, NSStringFromClass([slider class])] stopTest:YES];
    }
    [self setValue:value forSlider:slider];
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

- (void)dismissPopover
{
    const NSTimeInterval tapDelay = 0.05;
    UIWindow *window = [[UIApplication sharedApplication] dimmingViewWindow];
    if (!window) {
        [self failWithError:[NSError KIFErrorWithFormat:@"Failed to find any dimming views in the application"] stopTest:YES];
    }
    UIView *touchView = [[window subviewsWithClassNamePrefix:@"UIDimmingView"] lastObject];
    
    if (!touchView) {
        touchView = [[window subviewsWithClassNamePrefix:@"_UITouchFallbackView"] lastObject];
    }
    [touchView tapAtPoint:CGPointMake(50.0f, 50.0f)];
    KIFRunLoopRunInModeRelativeToAnimationSpeed(kCFRunLoopDefaultMode, tapDelay, false);
}

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

- (void)tapRowAtIndexPath:(NSIndexPath *)indexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier
{
    UITableView *tableView;
    [self waitForAccessibilityElement:NULL view:&tableView withIdentifier:identifier tappable:NO];
    [self tapRowAtIndexPath:indexPath inTableView:tableView];
}

- (void)tapRowInTableViewWithAccessibilityLabel:(NSString *)tableViewLabel atIndexPath:(NSIndexPath *)indexPath
{
    UITableView *tableView = (UITableView *)[self waitForViewWithAccessibilityLabel:tableViewLabel];
    [self tapRowAtIndexPath:indexPath inTableView:tableView];
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

- (void)tapItemAtIndexPath:(NSIndexPath *)indexPath inCollectionViewWithAccessibilityIdentifier:(NSString *)identifier
{
    UICollectionView *collectionView;
    [self waitForAccessibilityElement:NULL view:&collectionView withIdentifier:identifier tappable:NO];
    [self tapItemAtIndexPath:indexPath inCollectionView:collectionView];
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

- (void)tapItemAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView
{
    UICollectionViewCell *cell;
    cell = [self waitForCellAtIndexPath:indexPath inCollectionView:collectionView];

    CGRect cellFrame = [cell.contentView convertRect:cell.contentView.frame toView:collectionView];
    [collectionView tapAtPoint:CGPointCenteredInRect(cellFrame)];

    [self waitForAnimationsToFinish];
}

- (void)swipeViewWithAccessibilityLabel:(NSString *)label inDirection:(KIFSwipeDirection)direction
{
    [self swipeViewWithAccessibilityLabel:label value:nil traits:UIAccessibilityTraitNone inDirection:direction];
}

- (void)swipeViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value inDirection:(KIFSwipeDirection)direction
{
    [self swipeViewWithAccessibilityLabel:label value:value traits:UIAccessibilityTraitNone inDirection:direction];
}

- (void)swipeViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits inDirection:(KIFSwipeDirection)direction
{
    UIView *viewToSwipe = nil;
    UIAccessibilityElement *element = nil;

    [self waitForAccessibilityElement:&element view:&viewToSwipe withLabel:label value:value traits:traits tappable:YES];

    [self swipeAccessibilityElement:element inView:viewToSwipe inDirection:direction];
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

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label
{
    [self pullToRefreshViewWithAccessibilityLabel:label value:nil pullDownDuration:0 traits:UIAccessibilityTraitNone];
}

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label pullDownDuration:(KIFPullToRefreshTiming) pullDownDuration
{
    [self pullToRefreshViewWithAccessibilityLabel:label value:nil pullDownDuration:pullDownDuration traits:UIAccessibilityTraitNone];
}

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value
{
    [self pullToRefreshViewWithAccessibilityLabel:label value:value pullDownDuration:0 traits:UIAccessibilityTraitNone];
}

- (void)pullToRefreshViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value pullDownDuration:(KIFPullToRefreshTiming) pullDownDuration traits:(UIAccessibilityTraits)traits
{
    UIView *viewToSwipe = nil;
    UIAccessibilityElement *element = nil;

    [self waitForAccessibilityElement:&element view:&viewToSwipe withLabel:label value:value traits:traits tappable:YES];

    [self pullToRefreshAccessibilityElement:element inView:viewToSwipe pullDownDuration:pullDownDuration];
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

- (void)scrollViewWithAccessibilityLabel:(NSString *)label byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction
{
    UIView *viewToScroll;
    UIAccessibilityElement *element;
    [self waitForAccessibilityElement:&element view:&viewToScroll withLabel:label value:nil traits:UIAccessibilityTraitNone tappable:NO];
    [self scrollAccessibilityElement:element inView:viewToScroll byFractionOfSizeHorizontal:horizontalFraction vertical:verticalFraction];
}

- (void)scrollViewWithAccessibilityIdentifier:(NSString *)identifier byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction
{
    UIView *viewToScroll;
    UIAccessibilityElement *element;
    [self waitForAccessibilityElement:&element view:&viewToScroll withIdentifier:identifier tappable:NO];
    [self scrollAccessibilityElement:element inView:viewToScroll byFractionOfSizeHorizontal:horizontalFraction vertical:verticalFraction];
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

    // Scrolling does not work if we are at the end of the view
    // So if our scroll start is equal to the heigh, inset 5
    if (scrollStart.x == CGRectGetWidth(elementFrame)) {
        if (scrollDisplacement.x < 0) {
            scrollStart.x -= CGRectGetWidth(elementFrame) * 0.05;
        } else {
            scrollStart.x += CGRectGetWidth(elementFrame) * 0.05;
        }

    }

    if (scrollStart.y == CGRectGetHeight(elementFrame)) {
        if (scrollDisplacement.y < 0) {
            scrollStart.y -= CGRectGetHeight(elementFrame) * 0.05;
        } else {
            scrollStart.y += CGRectGetHeight(elementFrame) * 0.05;
        }
    }

    [viewToScroll dragFromPoint:scrollStart displacement:scrollDisplacement steps:kNumberOfPointsInScrollPath];

    [self waitForAnimationsToFinish];
}

- (void)waitForFirstResponderWithAccessibilityLabel:(NSString *)label
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        BOOL didMatch = NO;
        NSArray *firstResponders = [[UIApplication sharedApplication] firstResponders];

        for (UIResponder *firstResponder in firstResponders) {
            UIResponder *foundResponder = firstResponder;
            if ([foundResponder isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                do {
                    foundResponder = [(UIView *)foundResponder superview];
                } while (foundResponder && ![foundResponder isKindOfClass:[UISearchBar class]]);
            }

            if (foundResponder.accessibilityLabel == label || [foundResponder.accessibilityLabel isEqualToString:label]) {
                didMatch = YES;
                break;
            }
        }

        KIFTestWaitCondition(didMatch, error, @"Expected to find a first responder with the accessibility label '%@', got: %@", label, firstResponders);
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitForFirstResponderWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        BOOL didMatchLabel = NO;
        BOOL didMatchTraits = NO;
        NSArray *firstResponders = [[UIApplication sharedApplication] firstResponders];

        for (UIResponder *firstResponder in firstResponders) {
            if (firstResponder.accessibilityLabel == label || [firstResponder.accessibilityLabel isEqualToString:label]) {
                didMatchLabel = YES;
            }
            if (firstResponder.accessibilityTraits & traits) {
                didMatchTraits = YES;
            }

            if (didMatchLabel && didMatchTraits) {
                break;
            }
        }
        
        // foundLabel == label checks for the case where both are nil.
        KIFTestWaitCondition(didMatchLabel, error, @"Expected to find a first responder with the accessibility label '%@', got: %@", label, firstResponders);
        KIFTestWaitCondition(didMatchTraits, error, @"Expected to find a first responder with accessibility traits, got: %@", firstResponders);
        
        return KIFTestStepResultSuccess;
    }];
}

- (UITableViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier
{
    return [self waitForCellAtIndexPath:indexPath inTableViewWithAccessibilityIdentifier:identifier atPosition:UITableViewScrollPositionMiddle];
}

- (UITableViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier atPosition:(UITableViewScrollPosition)position
{
    UITableView *tableView;
    [self waitForAccessibilityElement:NULL view:&tableView withIdentifier:identifier tappable:NO];
    return [self waitForCellAtIndexPath:indexPath inTableView:tableView atPosition:position];
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

    [tableView scrollToRowAtIndexPath:indexPath
                     atScrollPosition:position
                             animated:[[self class] testActorAnimationsEnabled]];

    __block UITableViewCell *cell = nil;
    __block CGFloat lastYOffset = CGFLOAT_MAX;
    [self runBlock:^KIFTestStepResult(NSError **error) {
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

- (UICollectionViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inCollectionViewWithAccessibilityIdentifier:(NSString *)identifier
{
    return [self waitForCellAtIndexPath:indexPath inCollectionViewWithAccessibilityIdentifier:identifier atPosition:UICollectionViewScrollPositionCenteredHorizontally |
            UICollectionViewScrollPositionCenteredVertically];
}

- (UICollectionViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inCollectionViewWithAccessibilityIdentifier:(NSString *)identifier atPosition:(UICollectionViewScrollPosition)position;
{
    UICollectionView *collectionView;
    [self waitForAccessibilityElement:NULL view:&collectionView withIdentifier:identifier tappable:NO];
    return [self waitForCellAtIndexPath:indexPath inCollectionView:collectionView atPosition:position];
}

- (UICollectionViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView
{
    return [self waitForCellAtIndexPath:indexPath inCollectionView:collectionView atPosition:UICollectionViewScrollPositionCenteredHorizontally |
            UICollectionViewScrollPositionCenteredVertically];
}

- (UICollectionViewCell *)waitForCellAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(UICollectionView *)collectionView atPosition:(UICollectionViewScrollPosition)position
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
                           atScrollPosition:position
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

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath inTableViewWithAccessibilityIdentifier:(NSString *)identifier
{
    UITableView *tableView;
    [self waitForAccessibilityElement:NULL view:&tableView withIdentifier:identifier tappable:NO];
    [self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath inTableView:tableView];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath inTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [self waitForCellAtIndexPath:sourceIndexPath inTableView:tableView];

    NSError *error = nil;
    if (![tableView dragCell:cell toIndexPath:destinationIndexPath error:&error]) {
        [self failWithError:error stopTest:YES];
    }
}

- (void)deactivateAppForDuration:(NSTimeInterval)duration {
    [system deactivateAppForDuration:duration];
}

-(void) tapStepperWithAccessibilityLabel: (NSString *)accessibilityLabel increment: (KIFStepperDirection) stepperDirection
{
    @autoreleasepool {
        UIView *view = nil;
        UIAccessibilityElement *element = nil;
        [self waitForAccessibilityElement:&element view:&view withLabel:accessibilityLabel value:nil traits:UIAccessibilityTraitNone tappable:YES];
        [self tapStepperWithAccessibilityElement:element increment:stepperDirection inView:view];
    }
}

//inspired by http://www.raywenderlich.com/61419/ios-ui-testing-with-kif
- (void)tapStepperWithAccessibilityElement:(UIAccessibilityElement *)element increment: (KIFStepperDirection) stepperDirection inView:(UIView *)view
{
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

- (CGRect) elementFrameForElement:(UIAccessibilityElement *)element andView:(UIView *)view
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

- (CGPoint) tappablePointInElement:(UIAccessibilityElement *)element andView:(UIView *)view
{
    CGRect elementFrame = [self elementFrameForElement:element andView:view];
    CGPoint tappablePoint = [view tappablePointInRect:elementFrame];

    return tappablePoint;
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

+ (BOOL)testActorAnimationsEnabled;
{
    return KIFUITestActorAnimationsEnabled;
}

+ (void)setTestActorAnimationsEnabled:(BOOL)animationsEnabled;
{
    KIFUITestActorAnimationsEnabled = animationsEnabled;
}

@end
