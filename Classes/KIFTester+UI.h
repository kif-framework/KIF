//
//  KIFTester+UI.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTester.h"
#import <UIKit/UIKit.h>

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

typedef CGPoint KIFDisplacement;

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

@interface KIFTester (UI)

/*!
 @abstract Waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -waitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 */
- (void)waitForViewWithAccessibilityLabel:(NSString *)label;

/*!
 @abstract Waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -waitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 */
- (void)waitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;


/*!
 @abstract Waits until a view or accessibility element is present.
 @discussion The view or accessibility element with the given label is found in the view hierarchy. If the element isn't found, then the step will attempt to wait until it is. Note that the view does not necessarily have to be visible on the screen, and may be behind another view or offscreen. Views with their hidden property set to YES are ignored.
 
 If the view you want to wait for is tappable, use the -waitForTappableViewWithAccessibilityLabel: methods instead as they provide a more strict test.
 @param label The accessibility label of the element to wait for.
 @param value The accessibility value of the element to tap.
 @param traits The accessibility traits of the element to wait for. Elements that do not include at least these traits are ignored.
 @result A configured test step.
 */
- (void)waitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label;
- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
- (void)waitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;


- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label;
- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
- (void)waitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

- (void)tapViewWithAccessibilityLabel:(NSString *)label;
- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
- (void)tapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

- (void)tapScreenAtPoint:(CGPoint)screenPoint;

- (void)longPressViewWithAccessibilityLabel:(NSString *)label duration:(NSTimeInterval)duration;
- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value duration:(NSTimeInterval)duration;
- (void)longPressViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits duration:(NSTimeInterval)duration;

- (void)enterTextIntoCurrentFirstResponder:(NSString *)text;

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult;

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label;
- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult;

- (void)selectPickerViewRowWithTitle:(NSString *)title;
- (void)setOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label;
- (void)dismissPopover;

- (void)choosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
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
