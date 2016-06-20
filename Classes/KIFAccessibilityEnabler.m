//
//  KIFAccessibilityEnabler.m
//  KIF
//
//  Created by Timothy Clem on 10/11/15.
//
//

#import "KIFAccessibilityEnabler.h"
#import <XCTest/XCTest.h>
#import <dlfcn.h>

@interface KIFAccessibilityEnabler ()

@property (nonatomic, strong) id axSettingPrefController;

@end


@implementation KIFAccessibilityEnabler

+ (instancetype)sharedAccessibilityEnabler
{
    static dispatch_once_t onceToken;
    static KIFAccessibilityEnabler *_sharedAccessibilityEnabler;
    dispatch_once(&onceToken, ^{
        _sharedAccessibilityEnabler = [[self alloc] init];
    });

    return _sharedAccessibilityEnabler;
}

- (void)setApplicationAccessibilityEnabled:(BOOL)enabled
{
    CFPreferencesSetAppValue((CFStringRef)@"ApplicationAccessibilityEnabled",
                             kCFBooleanTrue, (CFStringRef)@"com.apple.Accessibility");
    CFPreferencesSynchronize((CFStringRef)@"com.apple.Accessibility",
                             kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                         (CFStringRef)@"com.apple.accessibility.cache.app.ax",
                                         nil, nil, enabled);
}

- (void)enableAccessibility
{
    [self setApplicationAccessibilityEnabled:YES];
}

- (void)_resetAccessibilityInspector
{
    [self setApplicationAccessibilityEnabled:NO];
}

@end

void ResetAccessibilityInspector(void);

// It appears that if you register as a test observer too late, then you don't get the testBundleDidFinish: method called, so instead we use this is a workaround. This is also works well for test envs that don't have XCTestObservation
__attribute__((destructor))
void ResetAccessibilityInspector() {
  [[KIFAccessibilityEnabler sharedAccessibilityEnabler] _resetAccessibilityInspector];
}
