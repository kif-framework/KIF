//
//  KIFTestScenario+EXAdditions.h
//  Testable
//
//  Created by Eric Firestone on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KIF/KIFTestScenario.h>

@interface KIFTestScenario (EXAdditions)

+ (id)scenarioToLogin;

+ (id)scenarioToSelectColor:(NSString *)colorName;

@end
