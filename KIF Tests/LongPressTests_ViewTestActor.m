//
//  ViewLongPressTests.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import <KIF/KIF.h>

@implementation KIFUIViewTestActor (longPressTests)

-(instancetype)greeting;
{
    return [viewTester usingAccessibilityLabel:@"Greeting"];
}

-(instancetype)selectAll;
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
    [[viewTester greeting] longPressWithDuration:2];
    [[viewTester selectAll] tap];
}

- (void)testLongPressingViewViewWithTraits
{
    [[[viewTester greeting] usingValue:@"Hello"] longPressWithDuration:2];
    [[viewTester selectAll] tap];
}

- (void)testLongPressingViewViewWithValue
{
    [[[[viewTester greeting] usingValue:@"Hello"] usingTraits:UIAccessibilityTraitUpdatesFrequently] longPressWithDuration:2];
    [[viewTester selectAll] tap];
}

@end