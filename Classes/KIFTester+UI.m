//
//  KIFTester+UI.m
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTester+UI.h"
#import "UIApplication-KIFAdditions.h"

@implementation KIFTester (UI)

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label
{
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone];
    
    NSMutableString *text = [NSMutableString string];
    for (NSInteger i = 0; i < element.accessibilityValue.length; i ++) {
        [text appendString:@"\b"];
    }
    
    [self enterText:text intoViewWithAccessibilityLabel:label];
}

- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToEnterText:text intoViewWithAccessibilityLabel:label]];
}

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label
{
    [self clearTextFromViewWithAccessibilityLabel:label];
    [self enterText:text intoViewWithAccessibilityLabel:label];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToTapViewWithAccessibilityLabel:label]];
}

- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits
{
    [self run:[KIFTestStep stepToTapViewWithAccessibilityLabel:label traits:traits]];
}

- (void)waitForViewWithAccessibilityLabel:(NSString *)label
{
    [self run:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:label]];
}

@end

/*
+ (id)stepWithDescription:(NSString *)description executionBlock:(KIFTestStepExecutionBlock)executionBlock;
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label;
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
+ (id)stepToWaitForViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label;

+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;


+ (id)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;


+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label;

+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

+ (id)stepToWaitForTappableViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;

+ (id)stepToWaitForTimeInterval:(NSTimeInterval)interval description:(NSString *)description;

+ (id)stepToWaitForNotificationName:(NSString*)name object:(id)object;

+ (id)stepToWaitForNotificationName:(NSString *)name object:(id)object whileExecutingStep:(KIFTestStep *)childStep;

+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label;

+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
+ (id)stepToTapViewWithAccessibilityLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits;
+ (id)stepToTapScreenAtPoint:(CGPoint)screenPoint;
+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;

+ (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits expectedResult:(NSString *)expectedResult;

+ (id)stepToClearTextFromViewWithAccessibilityLabel:(NSString *)label;
+ (id)stepToClearTextFromViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

+ (NSArray *)stepsToClearAndEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;

+ (NSArray *)stepsToClearAndEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
+ (id)stepToSelectPickerViewRowWithTitle:(NSString *)title;
+ (id)stepToSetOn:(BOOL)switchIsOn forSwitchWithAccessibilityLabel:(NSString *)label;
+ (id)stepToDismissPopover;
+ (id)stepToSimulateMemoryWarning;
+ (void)stepFailed;
+ (NSArray *)stepsToChoosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
+ (id)stepToTapRowInTableViewWithAccessibilityLabel:(NSString*)tableViewLabel atIndexPath:(NSIndexPath *)indexPath;
+ (id)stepToSwipeViewWithAccessibilityLabel:(NSString *)label inDirection:(KIFSwipeDirection)direction;
+ (id)stepToWaitForFirstResponderWithAccessibilityLabel:(NSString *)label;
*/
