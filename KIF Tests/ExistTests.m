//
//  ExistTests.m
//  KIF
//
//  Created by Jeroen Leenarts on 11-07-14.
//
//

#import <KIF/KIF.h>

@interface ExistTests : KIFTestCase

@end

@implementation ExistTests

- (void)testExistsViewWithAccessibilityLabel
{
    if ([tester existsTappableViewWithAccessibilityLabel:@"Tapping"] && ![tester existsTappableViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton]) {
        [tester tapViewWithAccessibilityLabel:@"Tapping"];
    } else {
        [tester fail];
    }
    
    if ([tester existsTappableViewWithAccessibilityLabel:@"Test Suite"] && ![tester existsTappableViewWithAccessibilityLabel:@"Tapping"]) {
        [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
    } else {
        [tester fail];
    }
}


@end
