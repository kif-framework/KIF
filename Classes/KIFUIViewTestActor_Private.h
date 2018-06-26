//
//  KIFUIViewTestActor_protected.h
//  KIF
//
//  Created by Alex Odawa on 6/27/18.
//

#import "KIFUIViewTestActor.h"

@class KIFUIObject;

@interface KIFUIViewTestActor ()

/*!
 @abstract Selects an item from a currently visible picker view in specified component and in the specified order to search the value it selects.
 @discussion With a picker view already visible, this step will find an item with the given title in given component, according to the search order specified, select that item, and tap the Done button. This is helpful when it is important to select values from specific location. Example: if minimum date is set, values from the start will be invalid for selection and result will be unexpected. KIFPickerSearchOrder helps solving this by specifing the search order.
 @param title The title of the row to select.
 @param component The component tester inteds to select the title in.
 @param picker The picker (if exists) found on predicate search
 @param searchOrder The order in which the values are being searched for selection in each compotent.
 */
- (void)selectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)component fromPicker:(UIPickerView *)picker withSearchOrder:(KIFPickerSearchOrder)searchOrder;

/*!
 @abstract Selects a value from a currently visible date picker view, according to the search order specified.
 @discussion With a date picker view already visible, this step will select the different rotating wheel values in order of how the array parameter is passed in. Each value will be searched according to the search order provided. After it is done it will hide the date picker. It works with all 4 UIDatePickerMode* modes. The input parameter of type NSArray has to match in what order the date picker is displaying the values/columns. So if the locale is changing the input parameter has to be adjusted. Example: Mode: UIDatePickerModeDate, Locale: en_US, Input param: NSArray *date = @[@"June", @"17", @"1965"];. Example: Mode: UIDatePickerModeDate, Locale: de_DE, Input param: NSArray *date = @[@"17.", @"Juni", @"1965".
 @param datePickerColumnValues Each element in the NSArray represents a rotating wheel in the date picker control. Elements from 0 - n are listed in the order of the rotating wheels, left to right.
 @param picker The picker (if exists) found on predicate search
 @param searchOrder The order in which the values are being searched for selection in each compotent.
 */
- (void)selectDatePickerValue:(NSArray *)datePickerColumnValues fromPicker:(UIPickerView *)picker withSearchOrder:(KIFPickerSearchOrder)searchOrder;


- (void)tapAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)view;

- (void)longPressAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)view duration:(NSTimeInterval)duration;

- (void)swipeAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)viewToSwipe inDirection:(KIFSwipeDirection)direction;

- (void)waitForAccessibilityElement:(UIAccessibilityElement * __autoreleasing *)element view:(out UIView * __autoreleasing *)view withElementMatchingPredicate:(NSPredicate *)predicate tappable:(BOOL)mustBeTappable;

- (void)scrollAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)viewToScroll byFractionOfSizeHorizontal:(CGFloat)horizontalFraction vertical:(CGFloat)verticalFraction;

- (void)enterText:(NSString *)text intoElement:(UIAccessibilityElement *)element inView:(UIView *)view expectedResult:(NSString *)expectedResult;

- (void)clearTextFromElement:(UIAccessibilityElement *)element inView:(UIView *)view;

- (void)setValue:(float)value forSlider:(UISlider *)slider;

- (void)setSwitch:(UISwitch *)switchView element:(UIAccessibilityElement *)element On:(BOOL)switchIsOn;


/*!
 @abstract Taps the increment|decrement button of a UIStepper view in the view heirarchy.
 @discussion This will locate the left or right half of the stepper and perform a calculated click. Unlike the -tapStepperToIncrement: method, this method allows you to tap an arbitrary element.  Combined with -waitForAccessibilityElement:view:withLabel:value:traits:tappable: or +[UIAccessibilityElement accessibilityElement:view:withLabel:value:traits:tappable:error:] this provides an opportunity for more complex logic
 @param element The accessibility element to tap.
 @param view The view containing the accessibility element.
 @param stepperDirection The direction in which to change the value of the stepper (KIFStepperDirectionIncrement | KIFStepperDirectionDecrement)
 */
- (void)tapStepperWithAccessibilityElement:(UIAccessibilityElement *)element increment:(KIFStepperDirection)stepperDirection inView:(UIView *)view;


- (void)pullToRefreshAccessibilityElement:(UIAccessibilityElement *)element inView:(UIView *)viewToSwipe pullDownDuration:(KIFPullToRefreshTiming) pullDownDuration;


- (BOOL)tryFindingAccessibilityElement:(out UIAccessibilityElement **)element view:(out UIView **)view withElementMatchingPredicate:(NSPredicate *)predicate tappable:(BOOL)mustBeTappable error:(out NSError **)error;


- (void)waitForDeleteStateForCellAtIndexPath:(NSIndexPath*)indexPath inTableView:(UITableView*)tableView;
- (void)swipeRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView inDirection:(KIFSwipeDirection)direction;


#pragma mark - Predicate

- (KIFUIObject *)predicateSearchWithRequiresMatch:(BOOL)requiresMatch mustBeTappable:(BOOL)tappable;


#pragma mark - Getters

- (UIView *)view;

- (UIAccessibilityElement *)element;

@end
