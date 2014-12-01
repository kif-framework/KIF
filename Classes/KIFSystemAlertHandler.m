//
//  KIFSystemAlertHandler.m
//  KIF
//
//  Created by Joe Masilotti on 12/1/14.
//
//

#import "KIFSystemAlertHandler.h"
#include <dlfcn.h>

@interface UIAElement : NSObject <NSCopying>
- (void)tap;
@end

@interface UIAAlert : UIAElement
- (NSArray *)buttons;
@end

@interface UIAApplication : UIAElement
- (UIAAlert *)alert;
@end

@interface UIATarget : UIAElement
+ (UIATarget *)localTarget;
- (UIAApplication *)frontMostApp;
@end

@implementation KIFSystemAlertHandler

+ (void)acknowledgeSystemAlert {
    // Dynamically link the private UIAutomation framework
    dlopen([@"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator8.1.sdk/Developer/Library/PrivateFrameworks/UIAutomation.framework/UIAutomation" fileSystemRepresentation], RTLD_LOCAL);

    // Directly accessing these class methods cause linker errors
    Class Target = NSClassFromString(@"UIATarget");
    Class NilElement = NSClassFromString(@"UIAElementNil");

    UIATarget *target = [Target localTarget];
    UIAApplication *app = target.frontMostApp;
    UIAAlert *alert = app.alert;
    [[alert.buttons lastObject] tap];

    // Run until the alert is dismissed
    do {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    } while (![app.alert isKindOfClass:[NilElement class]]);
}

@end
