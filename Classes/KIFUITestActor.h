//
//  KIFTester+UI.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestActor.h"
#import <UIKit/UIKit.h>
#import "UIView-KIFAdditions.h"

#define tester KIFActorWithClass(KIFUITestActor)

/*!
 @enum KIFSwipeDirection
 @abstract Directions in which to swipe.
 @constant KIFSwipeDirectionRight Swipe to the right.
 @constant KIFSwipeDirectionLeft Swipe to the left.
 @constant KIFSwipeDirectionUp Swipe up.
 @constant KIFSwipeDirectionDown Swipe down.
 */
typedef NS_ENUM(NSUInteger, KIFSwipeDirection) {
    KIFSwipeDirectionRight,
    KIFSwipeDirectionLeft,
    KIFSwipeDirectionUp,
    KIFSwipeDirectionDown
};

#define kKIFMajorSwipeDisplacement 200
#define kKIFMinorSwipeDisplacement 5

static inline KIFDisplacement KIFDisplacementForSwipingInDirection(KIFSwipeDirection direction)
{
    switch (direction)
    {
            // As discovered on the Frank mailing lists, it won't register as a
            // swipe if you move purely horizontally or vertically, so need a
            // slight orthogonal offset too.
        case KIFSwipeDirectionRight:
            return CGPointMake(kKIFMajorSwipeDisplacement, kKIFMinorSwipeDisplacement);
        case KIFSwipeDirectionLeft:
            return CGPointMake(-kKIFMajorSwipeDisplacement, kKIFMinorSwipeDisplacement);
        case KIFSwipeDirectionUp:
            return CGPointMake(kKIFMinorSwipeDisplacement, -kKIFMajorSwipeDisplacement);
        case KIFSwipeDirectionDown:
            return CGPointMake(kKIFMinorSwipeDisplacement, kKIFMajorSwipeDisplacement);
    }
}

@interface KIFUITestActor : KIFTestActor

/*!
 @abstract Waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -waitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 */
- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -waitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 */
- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;


/*!
 @abstract Waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -waitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
- (UIView *)waitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @abstract Waits until a view or accessibility element is no longer present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element is found, then the step will attempt to wait until it isn't. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are considered absent.
 @param label The accessibility label of the element to wait for.
 */
- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Waits until a view or accessibility element is no longer present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element is found, then the step will attempt to wait until it isn't. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are considered absent.
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 */
- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @abstract Waits until a view or accessibility element is no longer present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element is found, then the step will attempt to wait until it isn't. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are considered absent.
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 */
- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @abstract Waits until a view or accessibility element is present and available for tapping.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Whether or not a view is tappable is based on -[UIView hitTest:].
 @param label The accessibility label of the element to wait for.
 */
- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Waits until a view or accessibility element is present and available for tapping.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Whether or not a view is tappable is based on -[UIView hitTest:].
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 */
- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @abstract Waits until a view or accessibility element is present and available for tapping.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Whether or not a view is tappable is based on -[UIView hitTest:].
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 */
- (UIView *)waitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;


/*
 @abstract Waits for an accessibility element and its containing view based on a variety of criteria.
 @discussion This method provides a more verbose API for achieving what is available in the waitForView/waitForTappableView family of methods, exposing both the found element and its containing view.
 @param element To be populated with the matching accessibility element when found.  Can be NULL.
 @param view To be populated with the matching view when found.  Can be NULL.
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @param mustBeTappable If YES, only an element that can be tapped on will be returned.
 */
- (void)waitForAccessibilityElement:(UIAccessibilityElement **)element view:(out UIView **)view withLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable;

/*!
 @abstract Taps a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element.
 @param label The accessibility label of the element to tap.
 */
- (void)tapViewWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Taps a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element.
 @param label The accessibility label of the element to tap.
 @param traits The accessibility traits of the element to tap. Elements that do not include at least these traits are ignored.
 */
- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

/*!
 @abstract Taps a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element.
 
 This variation allows finding a particular instance of an accessibility element. For example, a table view might have multiple elements with the accessibility label of "Employee", but only one that also has the accessibility value of "Bob".
 @param label The accessibility label of the element to tap.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to tap. Elements that do not include at least these traits are ignored.
 */
- (void)tapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

/*!
 @abstract Taps a particular view in the view heirarchy.
 @discussion Unlike the -tapViewWithAccessibilityLabel: family of methods, this method allows you to tap an arbitrary element.  Combined with -waitForAccessibilityElement:view:withLabel:value:traits:tappable: or +[UIAccessibilityElement accessibilityElement:view:withLabel:value:traits:tappable:error:] this provides an opportunity for more complex logic.
 @param element The accessibility element to tap.
 @param view The view containing the accessibility element.
 */
- (void)tapAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)view;

/*!
 @abstract Taps the screen at a particular point.
 @discussion Taps the screen at a specific point. In general you should use the factory steps that tap a view based on its accessibility label, but there are situations where it's not possible to access a view using accessibility mechanisms. This step is more lenient than the steps that use the accessibility label, and does not wait for any particular view to appear, or validate that the tapped view is enabled or has interaction enabled. Because this step doesn't doesn't validate that a view is present before tapping it, it's good practice to precede this step where possible with a -waitForViewWithAccessibilityLabel: with the label for another view that should appear on the same screen.
 
 @param screenPoint The point in screen coordinates to tap. Screen points originate from the top left of the screen.
 */
- (void)tapScreenAtPoint:(CGPoint)screenPoint;

/*!
 @abstract Performs a long press on a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, touch events are simulated in the center of the view or element.
 @param label The accessibility label of the element to tap.
 @param duration The length of time to long press the element.
 */
- (void)longPressViewWithAccessibilityLabel:(NSString *)label duration:(NSTimeInterval)duration;

/*!
 @abstract Performs a long press on a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, touch events are simulated in the center of the view or element.
 
 This variation allows finding a particular instance of an accessibility element. For example, a table view might have multiple elements with the accessibility label of "Employee", but only one that also has the accessibility value of "Bob".
 @param label The accessibility label of the element to tap.
 @param value The accessibility value of the element to tap.
 @param duration The length of time to long press the element.
 */
- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value duration:(NSTimeInterval)duration;

/*!
 @abstract Performs a long press on a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, touch events are simulated in the center of the view or element.
 
 This variation allows finding a particular instance of an accessibility element. For example, a table view might have multiple elements with the accessibility label of "Employee", but only one that also has the accessibility value of "Bob".
 @param label The accessibility label of the element to tap.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to tap. Elements that do not include at least these traits are ignored.
 @param duration The length of time to long press the element.
 */
- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits duration:(NSTimeInterval)duration;

/*!
 @abstract Enters text into a the current first responder.
 @discussion Text is entered into the view by simulating taps on the appropriate keyboard keys if the keyboard is already displayed. Useful to enter text in UIWebViews or components with no accessibility labels.
 @param text The text to enter.
 */
- (void)enterTextIntoCurrentFirstResponder:(NSString *)text;

/*!
 @abstract Enters text into a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element, then text is entered into the view by simulating taps on the appropriate keyboard keys.
 @param text The text to enter.
 @param label The accessibility label of the element to type into.
 */
- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Enters text into a particular view in the view hierarchy.
 @discussion The view or accessibility element with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present and tappable, a tap event is simulated in the center of the view or element, then text is entered into the view by simulating taps on the appropriate keyboard keys.
 @param text The text to enter.
 @param label The accessibility label of the element to type into.
 @param traits The accessibility traits of the element to type into. Elements that do not include at least these traits are ignored.
 @param expectedResult What the text value should be after entry, including any formatting done by the field. If this is nil, the "text" parameter will be used.
 */
- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult;

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label;
- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult;

/*!
 @abstract ASelects an item from a currently visible picker view.
 @discussion With a picker view already visible, this step will find an item with the given title, select that item, and tap the Done button.
 @param title The title of the row to select.
 */
- (void)selectPickerViewRowWithTitle:(NSString *)title;

/*!
 @abstract Toggles a UISwitch into a specified position.
 @discussion The UISwitch with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present, the step will return if it's already in the desired position. If the switch is tappable but not in the desired position, a tap event is simulated in the center of the view or element, toggling the switch into the desired position.
 @param switchIsOn The desired position of the UISwitch.
 @param label The accessibility label of the element to switch.
 */
- (void)setOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Slides a UISlider to a specified value.
 @discussion The UISlider with the given label is searched for in the view hierarchy. If the element isn't found or isn't currently tappable, then the step will attempt to wait until it is. Once the view is present, the step will attempt to drag the slider to the new value.  The step will fail if it finds a view with the given accessibility label that is not a UISlider or if value is outside of the possible values.  Because this step simulates drag events, the value reached may not be the exact value requested and the app may ignore the touch events if the movement is less than the drag gesture recognizer's minimum distance.
 @param value The desired value of the UISlider.
 @param label The accessibility label of the element to drag.
 */
- (void)setValue:(float)value forSliderWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Dismisses a popover on screen.
 @discussion With a popover up, tap at the top-left corner of the screen.
 */
- (void)dismissPopover;

/*!
 @abstract Select a certain photo from the built in photo picker.
 @discussion This set of steps expects that the photo picker has been initiated and that the sheet is up. From there it will tap the "Choose Photo" button and select the desired photo.
 @param albumName The name of the album to select the photo from.
 @param row The row number in the album for the desired photo.
 @param column The column number in the album for the desired photo.
 */
- (void)choosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;

/*!
 @abstract Taps the row at IndexPath in a view with the given label.
 @discussion This step will get the view with the specified accessibility label and tap the row at indexPath.
 
 For cases where you may need to work from the end of a table view rather than the beginning, negative sections count back from the end of the table view (-1 is the last section) and negative rows count back from the end of the section (-1 is the last row for that section).
 @param tableViewLabel Accessibility label of the table view.
 @param indexPath Index path of the row to tap.
 */
- (void)tapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;

/*!
 @abstract Swipes a particular view in the view hierarchy in the given direction.
 @discussion The view will get the view with the specified accessibility label and swipe the screen in the given direction from the view's center.
 @param label The accessibility label of the view to swipe.
 @param direction The direction in which to swipe.
 */
- (void)swipeViewWithAccessibilityLabel:(NSString *)label inDirection:(KIFSwipeDirection)direction;

/*!
 @abstract Scrolls a particular view in the view hierarchy by an amount indicated as a fraction of its size.
 @discussion The view will get the view with the specified accessibility label and scroll it by the indicated fraction of its size, with the scroll centered on the center of the view.
 @param label The accessibility label of the view to scroll.
 @param horizontalFraction The horizontal displacement of the scroll action, as a fraction of the width of the view.
 @param verticalFraction The vertical displacement of the scroll action, as a fraction of the height of the view.
 */
- (void)scrollViewWithAccessibilityLabel:(NSString *)label byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction;

/*!
 @abstract Waits until a view or accessibility element is the first responder.
 @discussion The first responder is found by searching the view hierarchy of the application's
 main window and its accessibility label is compared to the given value. If they match, the
 step returns success else it will attempt to wait until they do.
 @param label The accessibility label of the element to wait for.
 */
- (void)waitForFirstResponderWithAccessibilityLabel:(NSString *)label;

@end
