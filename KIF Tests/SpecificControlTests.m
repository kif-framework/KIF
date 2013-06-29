//
//  SpecificControlTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface SpecificControlTests : KIFTestCase
@end

@implementation SpecificControlTests

- (void)beforeEach
{
    [tester tapViewWithAccessibilityLabel:@"Tapping"];
}

- (void)afterEach
{
    [tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}


- (void)testSelectingAPickerRow
{
    [tester selectPickerViewRowWithTitle:@"Charlie"];
    [tester waitForViewWithAccessibilityLabel:@"Call Sign" value:@"Charlie. 3 of 3" traits:UIAccessibilityTraitNone];
}

- (void)testTogglingASwitch
{
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone];
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"Happy"];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"0" traits:UIAccessibilityTraitNone];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Happy"];
    [tester waitForViewWithAccessibilityLabel:@"Happy" value:@"1" traits:UIAccessibilityTraitNone];
}

/*
 TODO: Add support for testing this iPad-only feature.
 + (id)stepToDismissPopover;
 */


/*
 TODO: Should we implement this test?  It is really domain specific. It depends on a UI element named "Choose Photo" which is wired to create an image picker, an album with a matching name, and photos to be on the device.
 + (NSArray *)stepsToChoosePhotoInAlbum:(NSString *)albumName atRow:(NSInteger)row column:(NSInteger)column;
 */

@end
