//
//  KIFApplication.h
//  Temperature
//
//  Created by Josh Abernathy on 7/16/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFElement.h"


@interface KIFApplication : KIFElement

+ (KIFApplication *)applicationWithCurrentApplication;
+ (KIFApplication *)applicationWithBundleIdentifier:(NSString *)bundleIdentifier;

@property (nonatomic, readonly) KIFElement *mainWindow;
@property (nonatomic, readonly) KIFElement *focusedWindow;
@property (nonatomic, readonly) NSArray *windows;

@end
