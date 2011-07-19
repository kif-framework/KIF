//
//  KIFTestStep-iOS.h
//  KIF
//
//  Created by Josh Abernathy on 7/18/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIFTestStep.h"


@interface KIFTestStep (iOS)

/*!
 @method stepToWaitForViewWithAccessibilityLabel:
 @abstract A step that waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view heirarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -stepToWaitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @result A configured test step.
 */
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label;

/*!
 @method stepToWaitForViewWithAccessibilityLabel:traits:
 @abstract A step that waits until a view or accessibility element is present.
 @discussionThe view or accessibility element with the given label is found in the view heirarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -stepToWaitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForViewWithAccessibilityLabel:traits:
 @abstract A step that waits until a view or accessibility element is present.
 @discussionThe view or accessibility element with the given label is found in the view heirarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -stepToWaitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @method stepToWaitForTappableViewWithAccessibilityLabel:
 @abstract A step that waits until a view or accessibility element is present and available for tapping.
 @discussion The view or accessibility element with the given label is found in the view heirarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Whether or not a view is tappable is based on -[UIView hitTest:].
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
 @method stepToWaitForTappableViewWithAccessibilityLabel:traits:
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

@end
