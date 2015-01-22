//
//  ViewLongPressTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@interface LongPressTests_ViewTestActor : KIFTestCase
@end


@implementation LongPressTests_ViewTestActor

- (void)beforeEach
{
    [[viewTester usingAccessibilityLabel:@"Tapping"] tap];
}

- (void)afterEach
{
    [[[viewTester usingAccessibilityLabel:@"Test Suite"] usingTraits:UIAccessibilityTraitButton] tap];
}

- (void)testLongPressingViewWithAccessibilityLabel
{
    [[viewTester usingAccessibilityLabel:@"Greeting"] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
}

- (void)testLongPressingViewViewWithTraits
{
    [[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
}

- (void)testLongPressingViewViewWithValue
{
    [[[[viewTester usingAccessibilityLabel:@"Greeting"] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitUpdatesFrequently] longPressWithDuration:2];
    [[viewTester usingAccessibilityLabel:@"Select All"] tap];
}

@end