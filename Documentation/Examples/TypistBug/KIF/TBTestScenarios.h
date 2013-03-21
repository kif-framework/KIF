//
//  TBTestScenarios.h
//  TypistBug
//
//  Created by Pete Hodgson on 3/20/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFTestScenario.h"

@interface KIFTestScenario (TBTestScenarios)

+ (id)scenarioToEnterTextWithCapitalization:(BOOL)autoCapitalize;

@end
