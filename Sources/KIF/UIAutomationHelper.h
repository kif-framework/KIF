//
//  UIAutomationHelper.h
//  KIF
//
//  Created by Joe Masilotti on 12/1/14.
//
//

#import <Foundation/Foundation.h>


@class KIFTestActor;

@interface UIAutomationHelper : NSObject

+ (BOOL)acknowledgeSystemAlert;

+ (BOOL)acknowledgeSystemAlertWithIndex:(NSUInteger)index;

+ (void)deactivateAppForDuration:(NSNumber *)duration;

@end
