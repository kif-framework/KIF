//
//  TBTestSteps.h
//  TypistBug
//
//  Created by Pete Hodgson on 3/20/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "KIFTestStep.h"

@interface KIFTestStep (TBTestSteps)

+ (id)stepToTypeIntoTheTextField:(NSString*)textToType;

@end
