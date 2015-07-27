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
    [[viewTester usingLabel:@"UIAlertView"] tap];
    [[viewTester usingLabel:@"Alert View"] waitForView];
    [[viewTester usingLabel:@"Message"] waitForView];
    [[viewTester usingLabel:@"Cancel"] waitToBecomeTappable];
    [[viewTester usingLabel:@"Continue"] waitToBecomeTappable];
    [[viewTester usingLabel:@"Continue"] tap];
    [[viewTester usingLabel:@"Message"] waitForAbsenceOfView];
}

- (void)testInteractionWithAnActionSheet
{
    [[viewTester usingLabel:@"UIActionSheet"] tap];
    [[viewTester usingLabel:@"Action Sheet"] waitForView];
    [[viewTester usingLabel:@"Destroy"] waitToBecomeTappable];
    [[viewTester usingLabel:@"A"] waitToBecomeTappable];
    [[viewTester usingLabel:@"B"] waitToBecomeTappable];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [viewTester dismissPopover];
    } else {
        [[viewTester usingLabel:@"Cancel"] tap];
    }
}

- (void)testInteractionWithAnActivityViewController
{
    if (!NSClassFromString(@"UIActivityViewController")) {
        return;
    }

    [[viewTester usingLabel:@"UIActivityViewController"] tap];
    [[viewTester usingLabel:@"Copy"] waitToBecomeTappable];
    [[viewTester usingLabel:@"Mail"] waitToBecomeTappable];
    [[viewTester usingLabel:@"Copy"] tap];
}

@end
