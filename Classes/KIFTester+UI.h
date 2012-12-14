//
//  KIFTester+UI.h
//  KIF
//
//  Created by Brian Nickel on 12/14/12.
//
//

#import "KIFTester.h"

@interface KIFTester (UI)

- (void)clearTextFromViewWithAccessibilityLabel:(NSString *)label;
- (void)enterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;

- (void)clearTextFromAndThenEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;

- (void)tapViewWithAccessibilityLabel:(NSString *)label;
- (void)tapViewWithAccessibilityLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;

- (void)waitForViewWithAccessibilityLabel:(NSString *)label;

@end
