//
//  KIFTestStep.h
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <UIKit/UIKit.h>


/*!
 @define KIFTestCondition
 @abstract Tests a condition and returns a failure result if the condition isn't true.
 @discussion This is a useful macro for quickly evaluating conditions in a test step. If the condition is false then the current test step will be aborted with a failure result.
 @param condition The condition to test.
 @param error The NSError object to put the error string into. May be nil, but should usually be the error parameter from the test step execution block.
 @param ... A string describing what the failure was that occurred. This may be a format string with additional arguments.
 */
#define KIFTestCondition(condition, error, ...) ({ \
if (!(condition)) { \
    if (error) { \
        *error = [NSError errorWithDomain:@"KIFTest" code:KIFTestStepResultFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:__VA_ARGS__], NSLocalizedDescriptionKey, nil]]; \
    } \
    [KIFTestStep stepFailed]; \
    return KIFTestStepResultFailure; \
} \
})

/*!
 @define KIFTestWaitCondition
 @abstract Tests a condition and returns a wait result if the condition isn't true.
 @discussion This is a useful macro for quickly evaluating conditions in a test step. If the condition is false then the current test step will be aborted with a wait result, indicating that it should be called again in the near future.
 @param condition The condition to test.
 @param error The NSError object to put the error string into. May be nil, but should usually be the error parameter from the test step execution block.
 @param ... A string describing why the step needs to wait. This is important since this reason will be considered the cause of a timeout error if the step requires waiting for too long. This may be a format string with additional arguments.
 */
#define KIFTestWaitCondition(condition, error, ...) ({ \
if (!(condition)) { \
    if (error) { \
    *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultWait userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:__VA_ARGS__], NSLocalizedDescriptionKey, nil]] autorelease]; \
    } \
    return KIFTestStepResultWait; \
} \
})


/*!
 @enum KIFTestStepResult
 @abstract Result codes from a test step.
 @constant KIFTestStepResultFailure The step failed and the test controller should move to the next scenario.
 @constant KIFTestStepResultSuccess The step succeeded and the test controller should move to the next step in the current scenario.
 @constant KIFTestStepResultWait The test isn't ready yet and should be tried again after a short delay.
 */
enum {
    KIFTestStepResultFailure = 0,
    KIFTestStepResultSuccess,
    KIFTestStepResultWait,
};
typedef NSInteger KIFTestStepResult;


@class KIFTestStep;

/*!
 @typedef KIFTestStepExecutionBlock
 @param step The step object itself. This is passed back to the block to ensure that there is a pointer to the fully initialized step at the time of execution.
 @param error An error to fill out in the case of a failure or wait condition. Filling out this error is mandatory in these cases to ensure that testing output is useful.
 @result A test result code. Returning KIFTestStepResultWait will cause the step to be tried again on the next iteration.
 */
typedef KIFTestStepResult (^KIFTestStepExecutionBlock)(KIFTestStep *step, NSError **error);

/*!
 @class KIFTestStep
 @abstract A step in a testing sequence.
 @discussion Steps are the most basic element of a test, and are added together to create the scenarios to be tested.
 
 Steps are the building blocks of scenarios, and should be very simple. A number of useful factory steps are provided for mimicking basic user interaction. These steps leverage the built in accessibility of iOS to find and interact with views. As such, the accessibility inspector needs to be enabled under Settings in the simulator for them to work.
 */
@interface KIFTestStep : NSObject {
    KIFTestStepExecutionBlock executionBlock;
    NSString *description;
    NSString *notificationName;
    id notificationObject;
    BOOL notificationOccurred;
    BOOL observingForNotification;
    NSTimeInterval timeout;    
}

/*!
 @property timeout
 @abstract The amount of time to try the step before assuming that it failed.
 @discussion The timeout comes into play if a step returns the KIFTestStepResultWait result. If the step returns this result such that the step has been called repeatedly for a time greater than the timeout, then the step is considered to have failed. Steps are assumed to be well-behaved, and the timeout will not interrupt a step if it is running synchronously for an extended period of time.
 */
@property (nonatomic) NSTimeInterval timeout;

/*!
 @property description
 @abstract A description of what the step does.
 @discussion This is used to help describe what the test script is doing and where it may have failed.
 */
@property (nonatomic, retain) NSString *description;

/*!
 @method defaultTimeout
 @abstract The default amount of time to assign to new steps before assuming they failed.
 @discussion To change the default value of the timeout property, either subclass KIFTestStep and override this method or call +setDefaultTimeout: with a different value.
 */
+ (NSTimeInterval)defaultTimeout;

/*!
 @method setDefaultTimeout:
 @abstract Sets the default amount of time to assign to new steps before assuming they failed.
 @discussion To change the default value of the timeout property, either subclass KIFTestStep and override +defaultTimeout or call this method with a different value.
 */
+ (void)setDefaultTimeout:(NSTimeInterval)newDefaultTimeout;

/*!
 @method stepWithDescription:executionBlock:
 @abstract Convenience initializer to create a new custom step.
 @param description A description of the what the step does. Required.
 @param executionBlock A block to execute which performs the step. Required.
 */
+ (id)stepWithDescription:(NSString *)description executionBlock:(KIFTestStepExecutionBlock)executionBlock;

/*!
 @method executeAndReturnError:
 @abstract Run the execution block for the receiver.
 @discussion This method should not usually be invoked directly. The test controller will handle invoking steps as needed.
 @param error An error that can be returned if the step fails or needs to wait.
 @result The result code for the result of executing the step.
 */
- (KIFTestStepResult)executeAndReturnError:(NSError **)error;

/*!
 @method cleanUp:
 @abstract Clean up any state and listeners once the step has completed.
 @discussion For anything that needs to be removed at completion rather than dealloc
 */
- (void)cleanUp;

#pragma mark Factory Steps

/*!
 @method stepThatFails
 @abstract A step that always fails.
 @discussion Mostly useful for test debugging or as a placeholder when building new tests.
 @result A configured test step.
 */
+ (id)stepThatFails;

/*!
 @method stepThatSucceeds
 @abstract A step that always succeeds.
 @discussion Mostly useful for test debugging or as a placeholder when building new tests.
 @result A configured test step.
 */
+ (id)stepThatSucceeds;

/*!
 @method stepToWaitForViewWithAccessibilityLabel:
 @abstract A step that waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -stepToWaitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @result A configured test step.
 */
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label;

/*!
 @method stepToWaitForViewWithAccessibilityLabel:traits:
 @abstract A step that waits until a view or accessibility element is present.
 @discussionThe view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -stepToWaitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForViewWithAccessibilityLabel:value:traits:
 @abstract A step that waits until a view or accessibility element is present.
 @discussionThe view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -stepToWaitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForAbsenceOfViewWithAccessibilityLabel:
 @abstract A step that waits until a view or accessibility element is no longer present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element is found, then the step will attempt to wait until it isn't. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are considered absent.
 @param label The accessibility label of the element to wait for.
 @result A configured test step.
 */
+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label;

/*!
 @method stepToWaitForAbsenceOfViewWithAccessibilityLabel:traits:
 @abstract A step that waits until a view or accessibility element is no longer present.
 @discussionThe view or accessibility element with the given label is found in the view hierarchy. If the element is found, then the step will attempt to wait until it isn't. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are considered absent.
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForAbsenceOfViewWithAccessibilityLabel:value:traits:
 @abstract A step that waits until a view or accessibility element is no longer present.
 @discussionThe view or accessibility element with the given label is found in the view hierarchy. If the element is found, then the step will attempt to wait until it isn't. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are considered absent.
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForTappableViewWithAccessibilityLabel:
 @abstract A step that waits until a view or accessibility element is present and available for tapping.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Whether or not a view is tappable is based on -[UIView hitTest:].
 @param label The accessibility label of the element to wait for.
 @result A configured test step.
 */
+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label;

/*!
 @method stepToWaitForTappableViewWithAccessibilityLabel:traits:
 @abstract A step that waits until a view or accessibility element is present and available for tapping.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Whether or not a view is tappable is based on -[UIView hitTest:].
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForTappableViewWithAccessibilityLabel:value:traits:
 @abstract A step that waits until a view or accessibility element is present and available for tapping.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Whether or not a view is tappable is based on -[UIView hitTest:].
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForTimeInterval:description:
 @abstract A step that waits for a certain amount of time.
 @discussion In general when waiting for the app to get into a known state, it's better to use -stepToWaitForTappableViewWithAccessibilityLabel, however this step may be useful in some situations as well.
 @param interval The number of seconds to wait before executing the next step.
 @param description A description of why the wait is necessary. Required.
 @result A configured test step.
 */
+ (id)stepToWaitForTimeInterval:(NSTimeInterval)interval description:(NSString *)description;

/*!
 @method stepToWaitForNotificationName:object:
 @abstract A step that waits for an NSNotification
 @discussion Useful when a test requires an asynchronous task to complete, especially when that task does not trigger a visible change in the view hierarchy
 @param name The name of the NSNotification
 @param object The object to which the step should listen. Nil value will listen to all objects.
 @result A configured test step.
 */
+ (id)stepToWaitForNotificationName:(NSString*)name object:(id)object;

/*!
 @method stepToTapViewWithAccessibilityLabel:
 @abstract A step that taps a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element.
 @param label The accessibility label of the element to tap.
 @result A configured test step.
 */
+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label;

/*!
 @method stepToTapViewWithAccessibilityLabel:traits:
 @abstract A step that taps a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element.
 @param label The accessibility label of the element to tap.
 @param traits The accessibility traits of the element to tap. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToTapViewWithAccessibilityLabel:value:traits:
 @abstract A step that taps a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element.
 
 This variation allows finding a particular instance of an accessibility element. For example, a table view might have multiple elements with the accessibility label of "Employee", but only one that also has the accessibility value of "Bob".
 @param label The accessibility label of the element to tap.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to tap. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToTapScreenAtPoint:
 @abstract A step that taps the screen at a particular point.
 @discussion Taps the screen at a specific point. In general you should use the factory steps that tap a view based on its accessibility label, but there are situations where it's not possible to access a view using accessibility mechanisms. This step is more lenient than the steps that use the accessibility label, and does not wait for any particular view to appear, or validate that the tapped view is enabled or has interaction enabled. Because this step doesn't doesn't validate that a view is present before tapping it, it's good practice to precede this step where possible with a -stepToWaitForViewWithAccessibilityLabel: with the label for another view that should appear on the same screen.
 
 @param screenPoint The point in screen coordinates to tap. Screen points originate from the top left of the screen.
 @result A configured test step.
 */
+ (id)stepToTapScreenAtPoint:(CGPoint)screenPoint;

/*!
 @method stepToEnterText:intoViewWithAccessibilityLabel:
 @abstract A step that enters text into a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element, then text is entered into the view by simulating taps on the appropriate keyboard keys.
 @param text The text to enter.
 @param label The accessibility label of the element to type into.
 @result A configured test step.
 */
+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;

/*!
 @method stepToEnterText:intoViewWithAccessibilityLabel:traits:
 @abstract A step that enters text into a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element, then text is entered into the view by simulating taps on the appropriate keyboard keys.
 @param text The text to enter.
 @param label The accessibility label of the element to type into.
 @param traits The accessibility traits of the element to type into. Elements that do not include at least these traits are ignored.
 @param expectedResult What the text value should be after entry, including any formatting done by the field. If this is nil, the "text" parameter will be used.
 @result A configured test step.
 */
+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult;

/*!
 @method stepToSelectPickerViewRowWithTitle:
 @abstract A step that selects an item from a currently visible picker view.
 @discussion With a picker view already visible, this step will find an item with the given title, select that item, and tap the Done button.
 @param title The title of the row to select.
 @result A configured test step.
 */
+ (id)stepToSelectPickerViewRowWithTitle:(NSString *)title;

/*!
 @method stepToSetOn:forSwitchWithAccessibilityLabel:
 @abstract A step that toggles a UISwitch into a specified position.
 @discussion The UISwitch with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present, the step will return if it's already in the desired position. If the switch is tappable but not in the desired position, a tap event is simulated in the center of the view or element, toggling the switch into the desired position.
 @param switchIsOn The desired position of the UISwitch.
 @param label The accessibility label of the element to switch.
 @result A configured test step.
 */
+ (id)stepToSetOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label;

/*!
 @method stepToDismissPopover
 @abstract A step that dismisses a popover on screen.
 @discussion With a popover up, tap at the top-left corner of the screen.
 @result A configured test step.
 */
+ (id)stepToDismissPopover;

/*!
 @method stepToSimulateMemoryWarning
 @abstract Simulates a memory warning.
 @result A configured test step.
 */
+ (id)stepToSimulateMemoryWarning;

+ (void)stepFailed;

/*!
 @method stepsToChoosePhotoInAlbum:atRow:column:
 @abstract Select a certain photo from the built in photo picker.
 @discussion This set of steps expects that the photo picker has been initiated and that the sheet is up. From there it will tap the "Choose Photo" button and select the desired photo.
 @param albumName The name of the album to select the photo from.
 @param row The row number in the album for the desired photo.
 @param column The column number in the album for the desired photo.
 @result An array of configured test steps.
 */
+ (NSArray *)stepsToChoosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;

/*!
 @method stepToTapRowInTableViewWithAccessibilityLabel:atIndexPath:
 @abstract A step that taps the row at IndexPath in a view with the given label.
 @discussion This step will get the view with the specified accessibility label and tap the row at indexPath.
 @param tableViewLabel Accessibility label of the table view.
 @param indexPath Index path of the row to tap.
 @result A configured test step.
 */
+ (id)stepToTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;

@end
