//
//  KIFUITestActor+IdentifierTests.h
//  KIF
//
//  Created by Brian Nickel on 11/6/14.
//
//

#import <KIF/KIF.h>

@interface KIFUITestActor (IdentifierTests)

- (UIView *)waitForViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
- (UIView *)waitForTappableViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
- (void)tapViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
- (void)waitForAbsenceOfViewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;

@end
