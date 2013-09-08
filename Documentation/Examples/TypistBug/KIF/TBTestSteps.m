//
//  TBTestSteps.m
//  TypistBug
//
//  Created by Pete Hodgson on 3/20/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "TBTestSteps.h"

@implementation KIFTestStep (TBTestSteps)

#pragma mark - Factory Steps

+ (NSArray *)stepsToTypeIntoTheTextField:(NSString*)textToType;
{
    return @[
        [self stepToEnterText:@"\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b" intoViewWithAccessibilityLabel:@"example text field" traits:UIAccessibilityTraitNone expectedResult:@""],
        [self stepToEnterText:textToType intoViewWithAccessibilityLabel:@"example text field"]
    ];
}

@end
