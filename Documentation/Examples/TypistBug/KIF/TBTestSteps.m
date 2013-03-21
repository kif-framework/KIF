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

+ (id)stepToTypeIntoTheTextField:(NSString*)textToType;
{
    return [self stepToEnterText:textToType intoViewWithAccessibilityLabel:@"Type into me"];
}

@end
