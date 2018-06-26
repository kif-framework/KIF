//
//  KIFEnumDefines.h
//  KIF
//
//  Created by Alex Odawa on 6/26/18.
//


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

/*!
 @enum KIFPickerType
 @abstract Picker type to select values from.
 @constant KIFUIPickerView UIPickerView type
 @constant KIFUIDatePicker UIDatePicker type
 */
typedef NS_ENUM(NSUInteger, KIFPickerType) {
    KIFUIPickerView,
    KIFUIDatePicker
};

/*!
 @enum KIFPickerSearchOrder
 @abstract Order in which to search picker values.
 @constant KIFPickerSearchForwardFromStart Search from first value forward.
 @constant KIFPickerSearchBackwardFromEnd Search from last value backwards.
 @constant KIFPickerSearchForwardFromCurrentValue Search from current value forward.
 @constant KIFPickerSearchBackwardFromCurrentValue Search from current value backwards.
 */
typedef NS_ENUM(NSUInteger, KIFPickerSearchOrder) {
    KIFPickerSearchForwardFromStart = 0,
    KIFPickerSearchBackwardFromEnd = 1,
    KIFPickerSearchForwardFromCurrentValue = 2,
    KIFPickerSearchBackwardFromCurrentValue = 3
};

/*!
 @enum KIFStepperDirection
 @abstract Direction in which to increment or decrement the stepper.
 @constant KIFStepperDirectionIncrement Increment the stepper
 @constant KIFUIDatePicker Decrement the stepper
 */
typedef NS_ENUM(NSUInteger, KIFStepperDirection) {
    KIFStepperDirectionIncrement,
    KIFStepperDirectionDecrement
};

/*!
 @enum KIFPullToRefreshTiming
 @discussion The approximate time in which the pull to refresh travels downward.
 @abstract Timing in which to perform the pull down before release.
 @constant KIFPullToRefreshInAboutAHalfSecond about half a second
 @constant KIFPullToRefreshInAboutOneSecond about one second
 @constant KIFPullToRefreshInAboutTwoSeconds about two seconds
 @constant KIFPullToRefreshInAboutThreeSeconds about three seconds.
 */
typedef NS_ENUM(NSUInteger, KIFPullToRefreshTiming) {
    KIFPullToRefreshInAboutAHalfSecond = 20, //faster
    KIFPullToRefreshInAboutOneSecond = 100,
    KIFPullToRefreshInAboutTwoSeconds = 150,
    KIFPullToRefreshInAboutThreeSeconds = 200, //slower
};
