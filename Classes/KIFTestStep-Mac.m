//
//  KIFTestStep-Mac.m
//  KIF
//
//  Created by Josh Abernathy on 7/23/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "KIFTestStep-Mac.h"
#import "KIFApplication.h"


@implementation KIFTestStep (Mac)

+ (id)stepToWaitForViewWithAccessibilityIdentifier:(NSString *)identifier {
	NSString *description = [NSString stringWithFormat:@"Wait for view with accessibility identifier \"%@\"", identifier];
        
    return [self stepWithDescription:description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
		KIFElement *element = [[KIFApplication currentApplication].mainWindow childWithIdentifier:identifier];
		return (element ? KIFTestStepResultSuccess : KIFTestStepResultWait);
    }];
}

+ (id)stepToClickViewWithAccessibilityIdentifier:(NSString *)identifier {
	NSString *description = [NSString stringWithFormat:@"Tap view with accessibility identifier \"%@\"", identifier];
    
    return [self stepWithDescription:description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
		KIFElement *element = [[KIFApplication currentApplication].mainWindow childWithIdentifier:identifier];
        if (!element) {
            return KIFTestStepResultWait;
        }
        
        [element performPressAction];
		
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        
        return KIFTestStepResultSuccess;
    }];
}

@end
