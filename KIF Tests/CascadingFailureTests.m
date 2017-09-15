//
//  CascadingFailureTests.m
//  Test Suite
//
//  Created by Brian Nickel on 8/4/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIF/KIF.h>
#import "KIFTestStepValidation.h"

@interface KIFSystemTestActor (CascadingFailureTests)
- (void)failA;
@end

@implementation KIFSystemTestActor (CascadingFailureTests)

- (void)failA
{
    [kif_system failB];
}

- (void)failB
{
    [kif_system failC];
}

- (void)failC
{
    [kif_system fail];
}

@end

@interface CascadingFailureTests : KIFTestCase
@end

@implementation CascadingFailureTests

- (void)testCascadingFailure
{
    KIFExpectFailure([kif_system failA]);
    KIFExpectFailureWithCount([kif_system failA], 4);
}

@end
