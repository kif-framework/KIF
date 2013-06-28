//
//  ModalViewTests.m
//  Test Suite
//
//  Created by Brian Nickel on 6/28/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>

@interface ModalViewTests : KIFTestCase
@end

@implementation ModalViewTests

- (void)testInteractionWithAnAlertView
{
    [tester tapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [tester waitForViewWithAccessibilityLabel:@"Alert View"];
    [tester waitForViewWithAccessibilityLabel:@"Message"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Cancel"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Continue"];
    [tester tapViewWithAccessibilityLabel:@"Continue"];
}

- (void)testInteractionWithAnActionSheet
{
    [tester tapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    [tester waitForViewWithAccessibilityLabel:@"Action Sheet"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Destroy"];
    [tester waitForTappableViewWithAccessibilityLabel:@"A"];
    [tester waitForTappableViewWithAccessibilityLabel:@"B"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Cancel"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
}

- (void)testInteractionWithAnActivitySheet
{
    [tester tapRowInTableViewWithAccessibilityLabel:@"Table View" atIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    [tester waitForTappableViewWithAccessibilityLabel:@"Copy"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Mail"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Cancel"];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
}

@end
