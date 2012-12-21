//
//  KIFTester+UI.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTester.h"

@interface KIFTester (UI)

- (void)waitForViewWithAccessibilityLabel:(NSString *)label;
- (void)waitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
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
- (void)swipeViewWithAccessibilityLabel:(NSString *)label inDirection:(KIFSwipeDirection)direction;
- (void)waitForFirstResponderWithAccessibilityLabel:(NSString *)label;

@end
