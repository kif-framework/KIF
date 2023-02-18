//
//  KIFUIViewActor.m
//  KIF
//
//  Created by Alex Odawa on 1/21/15.
//
//



#import "KIFUIViewTestActor.h"

#import "KIFUITestActor-ConditionalTests.h"
#import "KIFTestActor_Private.h"
#import "KIFUIObject.h"
#import "KIFUITestActor_Private.h"
#import "NSError-KIFAdditions.h"
#import "NSPredicate+KIFAdditions.h"
#import "NSString+KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"
#import "UIDatePicker+KIFAdditions.h"

@interface KIFUIViewTestActor ()

@property (nonatomic, strong, readonly) KIFUITestActor *actor;
@property (nonatomic, strong, readwrite) NSPredicate *predicate;
@property (nonatomic, assign) BOOL validateEnteredText;

@end


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
    [self _appendPredicate:predicate];
    return  self;
}

- (instancetype)usingLabel:(NSString *)accessibilityLabel;
{
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
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        id identifier = [evaluatedObject accessibilityIdentifier];

        return [accessibilityIdentifier KIF_isEqualToStringOrAttributedString:identifier];
    }];
    
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility identifier equal to \"%@\"", accessibilityIdentifier];

    return [self usingPredicate:predicate];
}

- (instancetype)usingTraits:(UIAccessibilityTraits)accessibilityTraits;
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ([evaluatedObject accessibilityTraits] & accessibilityTraits) == accessibilityTraits;
    }];
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility traits including \"%@\"", [UIAccessibilityElement stringFromAccessibilityTraits:accessibilityTraits]];
    
    return [self usingPredicate:predicate];
}

- (instancetype)usingAbsenceOfTraits:(UIAccessibilityTraits)accessibilityTraits;
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ([evaluatedObject accessibilityTraits] & accessibilityTraits) != accessibilityTraits;
    }];
    predicate.kifPredicateDescription = [NSString stringWithFormat:@"Accessibility traits excluding \"%@\"", [UIAccessibilityElement stringFromAccessibilityTraits:accessibilityTraits]];

    return [self usingPredicate:predicate];
}

- (instancetype)usingValue:(NSString *)accessibilityValue;
{
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

#if TARGET_IPHONE_SIMULATOR
- (BOOL)acknowledgeSystemAlert;
{
    return [self.actor acknowledgeSystemAlert];
}

- (BOOL)acknowledgeSystemAlertWithCompletionHandler:(void (^)(NSError*))completionHandler {
    [self safeAsyncCall:^{
        [self acknowledgeSystemAlert];
    } completionHandler:completionHandler];
}

#endif

- (void)tapStatusBar;
{
    [self.actor tapStatusBar];
}

- (void)tapStatusBarWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
        [self tapStatusBar];
    } completionHandler:completionHandler];
}

- (void)dismissPopover;
{
    [self.actor dismissPopover];
}

- (void)dismissPopoverWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
        [self dismissPopover];
    } completionHandler:completionHandler];
}

#pragma mark - Waiting

- (UIView *)waitForView;
{
    return [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO].view;
}

- (void)waitForViewWithCompletionHandler:(void (^)(UIView*, NSError* error))completionHandler
{
    [self safeAsyncCallWithReturnValue:^{
        return [self waitForView];
    } completionHandler:completionHandler];
}

- (void)waitForAbsenceOfView;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // If the app is ignoring interaction events, then wait before doing our analysis
        KIFTestWaitCondition(![[UIApplication sharedApplication] isIgnoringInteractionEvents], error, @"Application is ignoring interaction events.");
        
        // If the element can't be found, then we're done
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
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

- (void)waitForAbsenceOfViewWithCompletionHandler:(void (^ __nullable)(NSError* error))completionHandler {
     [self safeAsyncCall:^{
            [self waitForAbsenceOfView];;
    } completionHandler:completionHandler];
}

- (UIView *)waitForTappableView;
{
    return [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES].view;
}

- (void)waitForTappableViewWithCompletionHandler:(void (^)(UIView*, NSError*))completionHandler {
    [self safeAsyncCallWithReturnValue:^{
         return [self waitForTappableView];
    } completionHandler:completionHandler];
}

- (void)waitToBecomeTappable;
{
    [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
}

- (void)waitToBecomeFirstResponder;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        BOOL didMatch = NO;
        NSArray *firstResponders = [[UIApplication sharedApplication] firstResponders];

        for (UIResponder *firstResponder in firstResponders) {
            if ([self.predicate evaluateWithObject:firstResponder]) {
                didMatch = YES;
                break;
            }
        }

        KIFTestWaitCondition(didMatch, error, @"Expected to find a first responder matching '%@', got: %@", self.predicate.kifPredicateDescription, firstResponders);
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitToBecomeFirstResponderWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self waitToBecomeFirstResponder];
    } completionHandler:completionHandler];
}

- (void)waitForAnimationsToFinish;
{
    [self.actor waitForAnimationsToFinishWithTimeout:self.animationWaitingTimeout stabilizationTime:self.animationStabilizationTimeout];
}

- (void)waitForAnimationsToFinishWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self waitForAnimationsToFinish];
    } completionHandler:completionHandler];
}

#pragma mark Typist Waiting

- (void)waitForSoftwareKeyboard;
{
    [self.actor waitForSoftwareKeyboard];
}

- (void)waitForSoftwareKeyboardWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self waitForSoftwareKeyboard];
    } completionHandler:completionHandler];
}

- (void)waitForAbsenceOfSoftwareKeyboard;
{
    [self.actor waitForAbsenceOfSoftwareKeyboard];
}

- (void)waitForAbsenceOfSoftwareKeyboardWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self waitForAbsenceOfSoftwareKeyboard];
    } completionHandler:completionHandler];
}

- (void)waitForKeyInputReady;
{
    [self.actor waitForKeyInputReady];
}

- (void)waitForKeyInputReadyWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self waitForKeyInputReady];
    } completionHandler:completionHandler];
}

#pragma mark - Conditionals

- (BOOL)tryFindingView;
{
    return ([self _predicateSearchWithRequiresMatch:NO mustBeTappable:NO] != nil);
}

- (void)tryFindingViewWithCompletionHandler:(void (^)(BOOL, NSError*))completionHandler {
    @try {
        BOOL result = [self tryFindingView];
        completionHandler(result, nil);
    } @catch (NSException *exception) {
        completionHandler(false, [NSError KIFErrorFromException: exception]);
    }
}

- (BOOL)tryFindingTappableView;
{
    return ([self _predicateSearchWithRequiresMatch:NO mustBeTappable:YES] != nil);
}

- (void)tryFindingTappableViewWithCompletionHandler:(void (^)(BOOL, NSError*))completionHandler {
    @try {
        BOOL result = [self tryFindingTappableView];
        completionHandler(result, nil);
    } @catch (NSException *exception) {
        completionHandler(false, [NSError KIFErrorFromException: exception]);
    }
}

#pragma mark - Tap Actions

- (void)tap;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
        [self.actor tapAccessibilityElement:found.element inView:found.view];
    }
}



-(void)tapWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self tap];;
    } completionHandler:completionHandler];
}

- (void)longPress;
{
    [self longPressWithDuration:.5];
}

- (void)longPressWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self longPress];
    } completionHandler:completionHandler];
}

- (void)longPressWithDuration:(NSTimeInterval)duration;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
        [self.actor longPressAccessibilityElement:found.element inView:found.view duration:duration];
    }
}

- (void)longPressWithDuration:(NSTimeInterval)duration completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self longPressWithDuration:duration];
    } completionHandler:completionHandler];
}

#pragma mark - Text Actions;

- (void)clearText;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor clearTextFromElement:found.element inView:found.view];
    }
}

- (void)clearTextWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self clearText];
    } completionHandler:completionHandler];
}

- (void)clearTextFromFirstResponder;
{
    [self.actor clearTextFromFirstResponder];
}

- (void)enterText:(NSString *)text;
{
    [self enterText:text expectedResult:nil];
}

- (void)enterText:(NSString *)text completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self enterText:text];
    } completionHandler:completionHandler];
}

- (void)enterText:(NSString *)text expectedResult:(NSString *)expectedResult;
{
    if (!self.validateEnteredText && expectedResult) {
        [self failWithMessage:@"Can't supply an expectedResult string if `validateEnteredText` is NO."];
    }

    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor enterText:text intoElement:found.element inView:found.view expectedResult:expectedResult];
    }
}

- (void)enterText:(NSString *)text expectedResult:(NSString *)expectedResult completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self enterText:text expectedResult:expectedResult];
    } completionHandler:completionHandler];
}

- (void)clearAndEnterText:(NSString *)text;
{
    [self clearAndEnterText:text expectedResult:nil];
}

- (void)clearAndEnterText:(NSString *)text completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self clearAndEnterText:text];
    } completionHandler:completionHandler];
}

- (void)clearAndEnterText:(NSString *)text expectedResult:(NSString *)expectedResult;
{
    [self clearText];
    [self enterText:text expectedResult:expectedResult];
}

- (void)clearAndEnterText:(NSString *)text expectedResult:(NSString *)expectedResult completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self clearAndEnterText:text expectedResult:expectedResult];
    } completionHandler:completionHandler];
}

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text;
{
    [self.actor enterTextIntoCurrentFirstResponder:text];
}

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text fallbackView:(UIView *)fallbackView;
{
    [self.actor enterTextIntoCurrentFirstResponder:text fallbackView:fallbackView];
}

- (void)setText:(NSString *)text;
{
    [self runBlock:^KIFTestStepResult(NSError *__autoreleasing *error) {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
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

- (void)setText:(NSString *)text completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self setText:text];
    } completionHandler:completionHandler];
}

- (void)expectToContainText:(NSString *)expectedResult;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor expectView:found.view toContainText:expectedResult];
    }
}

- (void)expectToContainText:(NSString *)expectedResult completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self expectToContainText:expectedResult];
    } completionHandler:completionHandler];
}

#pragma mark - Touch Actions

- (void)tapScreenAtPoint:(CGPoint)screenPoint;
{
    [self.actor tapScreenAtPoint:screenPoint];
}

- (void)tapScreenAtPoint:(CGPoint)screenPoint completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self.actor tapScreenAtPoint:screenPoint];
    } completionHandler:completionHandler];
}

- (void)swipeInDirection:(KIFSwipeDirection)direction;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor swipeAccessibilityElement:found.element inView:found.view inDirection:direction];
    }
}

- (void)swipeInDirection:(KIFSwipeDirection)direction completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self swipeInDirection:direction];
    } completionHandler:completionHandler];
}

#pragma mark - Scroll/Table/CollectionView Actions

- (void)scrollByFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor scrollAccessibilityElement:found.element inView:found.view byFractionOfSizeHorizontal:horizontalFraction vertical:verticalFraction];
    }
}

- (void)scrollByFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction  completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self scrollByFractionOfSizeHorizontal:horizontalFraction vertical:verticalFraction];
    } completionHandler:completionHandler];
}

- (void)tapRowInTableViewAtIndexPath:(NSIndexPath *)indexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UITableView class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor tapRowAtIndexPath:indexPath inTableView:(UITableView *)found.view];
    }
}

- (void)tapRowInTableViewAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self tapRowInTableViewAtIndexPath:indexPath];
    } completionHandler:completionHandler];
}

- (UITableViewCell *)waitForCellInTableViewAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self waitForCellInTableViewAtIndexPath:indexPath atPosition:UITableViewScrollPositionMiddle];
}

- (void)waitForCellInTableViewAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^)(UITableViewCell*, NSError*))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            UITableViewCell* cell = [self waitForCellInTableViewAtIndexPath:indexPath];
            completionHandler(cell, nil);
        } @catch (NSException *exception) {
            completionHandler(nil, [NSError KIFErrorFromException: exception]);
        }
    });
}

- (UITableViewCell *)waitForCellInTableViewAtIndexPath:(NSIndexPath *)indexPath atPosition:(UITableViewScrollPosition)position;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UITableView class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        return [self.actor waitForCellAtIndexPath:indexPath inTableView:(UITableView *)found.view atPosition:position];
    }
}

- (void)waitForCellInTableViewAtIndexPath:(NSIndexPath *)indexPath atPosition:(UITableViewScrollPosition)position completionHandler:(void (^)(UITableViewCell*, NSError*))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            UITableViewCell* cell = [self waitForCellInTableViewAtIndexPath:indexPath atPosition:position];
            completionHandler(cell, nil);
        } @catch (NSException *exception) {
            completionHandler(nil, [NSError KIFErrorFromException: exception]);
        }
    });
}

- (void)moveRowInTableViewAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UITableView class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath inTableView:(UITableView *)found.view];
    }
}

- (void)moveRowInTableViewAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self moveRowInTableViewAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    } completionHandler:completionHandler];
}


- (void)tapCollectionViewItemAtIndexPath:(NSIndexPath *)indexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UICollectionView class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor tapItemAtIndexPath:indexPath inCollectionView:(UICollectionView *)found.view];
    }
}

- (void)tapCollectionViewItemAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self tapCollectionViewItemAtIndexPath:indexPath];
    } completionHandler:completionHandler];
}

- (UICollectionViewCell *)waitForCellInCollectionViewAtIndexPath:(NSIndexPath *)indexPath;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UICollectionView class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        return [self.actor waitForCellAtIndexPath:indexPath inCollectionView:(UICollectionView *)found.view];
    }
}

- (void)waitForCellInCollectionViewAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^)(UICollectionViewCell*, NSError*))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            UICollectionViewCell* view = [self waitForCellInCollectionViewAtIndexPath:indexPath];
            completionHandler(view, nil);
        } @catch (NSException *exception) {
            completionHandler(nil, [NSError KIFErrorFromException: exception]);
        }
    });
}

#pragma mark - UIControl Actions

- (void)setSliderValue:(float)value;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UISlider class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor setValue:value forSlider:(UISlider *)found.view];
    }
}

- (void)setSliderValue:(float)value completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self setSliderValue:value];
    } completionHandler:completionHandler];
}

- (void)setSwitchOn:(BOOL)switchIsOn;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UISwitch class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor setSwitch:(UISwitch *)found.view element:found.element On:switchIsOn];
    }
}

- (void)setSwitchOn:(BOOL)switchIsOn completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self setSwitchOn:switchIsOn];
    } completionHandler:completionHandler];
}

#pragma mark - Picker Actions

- (void)selectPickerViewRowWithTitle:(NSString *)title;
{
    [self selectPickerViewRowWithTitle:title inComponent:0];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self selectPickerViewRowWithTitle:title];
    } completionHandler:completionHandler];
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UIPickerView class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        UIPickerView *picker = (UIPickerView *) found.view;
        [self.actor selectPickerViewRowWithTitle:title inComponent:component fromPicker:picker withSearchOrder:KIFPickerSearchForwardFromStart];
    }
}

- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self selectPickerViewRowWithTitle:title inComponent:component];
    } completionHandler:completionHandler];
}

#pragma mark - Date Picker Actions

- (void)selectDatePickerDate:(NSDate *)date
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UIDatePicker class]] _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
        [(UIDatePicker *)found.view selectDate:date];
    }
}

- (void)selectDatePickerDate:(NSDate *)date completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self selectDatePickerDate:date];
    } completionHandler:completionHandler];
}

- (void)selectCountdownTimerDatePickerHours:(NSUInteger)hours minutes:(NSUInteger)minutes
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UIDatePicker class]] _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
        [(UIDatePicker *)found.view selectCountdownHours:hours minutes:minutes];
    }
}

- (void)selectCountdownTimerDatePickerHours:(NSUInteger)hours minutes:(NSUInteger)minutes completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self selectCountdownTimerDatePickerHours:hours minutes:minutes];
    } completionHandler:completionHandler];
}


#pragma mark - Deprecated Date Picker Actions

- (void)selectDatePickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UIDatePicker class]] _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        UIPickerView *picker = [self _getDatePickerViewFromPicker:found.view];
        [self.actor selectPickerViewRowWithTitle:title inComponent:component fromPicker:picker withSearchOrder:KIFPickerSearchForwardFromStart];
    }
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues;
{
    [self selectDatePickerValue:datePickerColumnValues withSearchOrder:KIFPickerSearchForwardFromStart];
}

- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues withSearchOrder:(KIFPickerSearchOrder)searchOrder;
{
    @autoreleasepool {
        KIFUIObject *found = [[self _usingExpectedClass:[UIDatePicker class]] _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
        [self.actor selectDatePickerValue:datePickerColumnValues fromPicker:(UIDatePicker *)found.view withSearchOrder:searchOrder];
    }
}

#pragma mark - Photo Picker

- (void)choosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
{
    [self.actor choosePhotoInAlbum:albumName atRow:row column:column];
}

- (void)choosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self choosePhotoInAlbum:albumName atRow:row column:column];
    } completionHandler:completionHandler];
}

#pragma mark - Pull to Refresh

- (void)pullToRefresh;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor pullToRefreshAccessibilityElement:found.element inView:found.view pullDownDuration:0];
    }
}

- (void)pullToRefreshWithCompletionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self pullToRefresh];
    } completionHandler:completionHandler];
}

- (void)pullToRefreshWithDuration:(KIFPullToRefreshTiming)pullDownDuration;
{
    @autoreleasepool {
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
        [self.actor pullToRefreshAccessibilityElement:found.element inView:found.view pullDownDuration:pullDownDuration];
    }
}

- (void)pullToRefreshWithDuration:(KIFPullToRefreshTiming)pullDownDuration completionHandler:(void (^)(NSError*))completionHandler {
     [self safeAsyncCall:^{
            [self pullToRefreshWithDuration:pullDownDuration];
    } completionHandler:completionHandler];
}

#pragma mark - Getters

- (UIView *)view;
{
    return [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO].view;
}

- (UIAccessibilityElement *)element;
{
    return [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO].element;
}

- (KIFUITestActor *)actor;
{
    return [[[[[KIFUITestActor actorInFile:self.file atLine:self.line delegate:self.delegate] usingTimeout:self.executionBlockTimeout] usingAnimationWaitingTimeout:self.animationWaitingTimeout] usingAnimationStabilizationTimeout:self.animationStabilizationTimeout] validateEnteredText:self.validateEnteredText];
}

#pragma mark - NSObject

- (NSString *)description;
{
    KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
    return [NSString stringWithFormat:@"<%@; view=%@; element=%@; predicate=%@>", [super description], found.view, found.element, self.predicate];
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

- (KIFUIObject *)_predicateSearchWithRequiresMatch:(BOOL)requiresMatch mustBeTappable:(BOOL)tappable;
{
    __block UIView *foundView = nil;
    __block UIAccessibilityElement *foundElement = nil;

    if (requiresMatch) {
        [self.actor waitForAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable];
    } else {
        NSError *error;
        [self tryRunningBlock:^KIFTestStepResult(NSError **error) {
            KIFTestWaitCondition([self.actor tryFindingAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable error:error], error, @"Waiting on view matching %@", self.predicate.kifPredicateDescription);
            return KIFTestStepResultSuccess;
        } complete:nil timeout:1.0 error:&error];
    }

    if (foundView && foundElement) {
        return [[KIFUIObject alloc] initWithElement:foundElement view:foundView];
    }
    return nil;
}

-(void)safeAsyncCall:(void (^)(void))call completionHandler:(void (^)(NSError*))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            call();
            completionHandler(nil);
        } @catch (NSException *exception) {
            completionHandler([NSError KIFErrorFromException: exception]);
        }
    });
}

-(void)safeAsyncCallWithReturnValue:(UIView* (^)(void))call completionHandler:(void (^)(UIView*, NSError*))completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            UIView* view = call();
            completionHandler(view, nil);
        } @catch (NSException *exception) {
            completionHandler(nil, [NSError KIFErrorFromException: exception]);
        }
    });
}

@end

