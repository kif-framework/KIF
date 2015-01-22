//
//  NewModalViewTests.m
//  KIF
//
//  Created by Alex Odawa on 1/27/15.
//
//

#import <KIF/KIF.h>

@interface ModalViewTests_ViewTestActor : KIFTestCase
@end

@implementation ModalViewTests_ViewTestActor

- (void)beforeEach
{
    [viewTester waitForTimeInterval:0.25];
}

- (void)testInteractionWithAnAlertView
{
    [[viewTester usingAccessibilityLabel:@"UIAlertView"] tap];
    [[viewTester usingAccessibilityLabel:@"Alert View"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Message"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Cancel"] waitToBecomeTappable];
    [[viewTester usingAccessibilityLabel:@"Continue"] waitToBecomeTappable];
    [[viewTester usingAccessibilityLabel:@"Continue"] tap];
    [[viewTester usingAccessibilityLabel:@"Message"] waitForAbsenceOfView];
}

- (void)testInteractionWithAnActionSheet
{
    [[viewTester usingAccessibilityLabel:@"UIActionSheet"] tap];
    [[viewTester usingAccessibilityLabel:@"Action Sheet"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Destroy"] waitToBecomeTappable];
    [[viewTester usingAccessibilityLabel:@"A"] waitToBecomeTappable];
    [[viewTester usingAccessibilityLabel:@"B"] waitToBecomeTappable];

    [self _dismissModal];
    
    [[viewTester usingAccessibilityLabel:@"Alert View"] waitForView];
    [[viewTester usingAccessibilityLabel:@"Continue"] tap];
    [[viewTester usingAccessibilityLabel:@"Alert View"] waitForAbsenceOfView];
}

- (void)testInteractionWithAnActivityViewController
{
    if (!NSClassFromString(@"UIActivityViewController")) {
        return;
    }

    [[viewTester usingAccessibilityLabel:@"UIActivityViewController"] tap];
    [[viewTester usingAccessibilityLabel:@"Copy"] waitToBecomeTappable];
    [[viewTester usingAccessibilityLabel:@"Mail"] waitToBecomeTappable];

    // On iOS7, the activity controller appears at the bottom
    // On iOS8 and beyond, it is shown in a popover control
    if ([UIDevice.currentDevice.systemVersion compare:@"8.0" options:NSNumericSearch] < 0) {
        [tester tapViewWithAccessibilityLabel:@"Cancel"];
    } else {
        [self _dismissModal];
    }
}

#pragma mark - Private Methods

- (void)_dismissModal;
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [tester dismissPopover];
    } else {
        [tester tapViewWithAccessibilityLabel:@"Cancel"];
    }
}

@end
