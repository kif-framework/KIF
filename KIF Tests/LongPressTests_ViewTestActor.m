//
//  ViewLongPressTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@implementation KIFUIViewTestActor (longPressTests)

-(instancetype)longPressTestGreeting;
{
    return [viewTester usingAccessibilityLabel:@"Greeting"];
}

-(instancetype)longPressTestSelectAll;
{
    return [viewTester usingAccessibilityLabel:@"Select All"];
}

@end

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
    [[viewTester longPressTestGreeting] longPressWithDuration:2];
    [[viewTester longPressTestSelectAll] tap];
}

- (void)testLongPressingViewViewWithTraits
{
    [[[viewTester longPressTestGreeting] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester longPressTestSelectAll] tap];
}

- (void)testLongPressingViewViewWithValue
{
    [[[[viewTester longPressTestGreeting] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitUpdatesFrequently] longPressWithDuration:2];
    [[viewTester longPressTestSelectAll] tap];
}

@end