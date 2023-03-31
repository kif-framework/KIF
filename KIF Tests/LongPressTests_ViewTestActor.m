//
//  ViewLongPressTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>
#import "NSString+KIFAdditionsTests.h"

@interface LongPressTests_ViewTestActor : KIFTestCase
@end


@implementation LongPressTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testLongPressingViewWithAccessibilityLabel
{
    [[viewTester usingLabel:@"Greeting"] tap];
    [[viewTester usingLabel:@"Greeting"] longPressWithDuration:2];
    [[viewTester usingLabel:[NSString textFieldLongPressSelectText]] tap];
}

- (void)testLongPressingViewViewWithTraits
{
    [[viewTester usingLabel:@"Greeting"] tap];
    [[[viewTester usingLabel:@"Greeting"] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester usingLabel:[NSString textFieldLongPressSelectText]] tap];
}

- (void)testLongPressingViewViewWithValue
{
    [[viewTester usingLabel:@"Greeting"] tap];
    [[[[viewTester usingLabel:@"Greeting"] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitUpdatesFrequently] longPressWithDuration:2];
    [[viewTester usingLabel:[NSString textFieldLongPressSelectText]] tap];
}

@end
