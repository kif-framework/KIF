//
//  KIFApplication.m
//
//  Created by Josh Abernathy on 7/16/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "KIFApplication.h"
#import "KIFElement-Private.h"

@interface KIFApplication ()
- (id)initWithPID:(pid_t)pid;
@end


@implementation KIFApplication


#pragma mark API

+ (KIFApplication *)currentApplication {
	static dispatch_once_t once;
    static KIFApplication *currentApplication = nil;
    dispatch_once(&once, ^{
		currentApplication = [[self applicationWithCurrentApplication] retain];
	});
    return currentApplication;
}

+ (KIFApplication *)applicationWithCurrentApplication {
	return [[[self alloc] initWithPID:[[NSRunningApplication currentApplication] processIdentifier]] autorelease];
}

+ (KIFApplication *)applicationWithBundleIdentifier:(NSString *)bundleIdentifier {
	NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier];
	NSAssert1(apps.count > 0, @"We couldn't find any apps with the bundle identifier: %@", bundleIdentifier);
	
	if(apps.count > 1) {
		NSLog(@"Whoa, we found multiple running apps with that bundle ID: %@. We're just going to use the last one.", apps);
	}
	
	return [[[self alloc] initWithPID:[[apps lastObject] processIdentifier]] autorelease];
}

- (id)initWithPID:(pid_t)pid {
	AXUIElementRef appRef = AXUIElementCreateApplication(pid);
	self = [super initWithElementRef:appRef];
	CFRelease(appRef);
	
	if(self == nil) return nil;
	
	return self;
}

- (KIFElement *)mainWindow {
	return [self wrappedAttributeForKey:NSAccessibilityMainWindowAttribute];
}

- (KIFElement *)focusedWindow {
	return [self wrappedAttributeForKey:NSAccessibilityFocusedWindowAttribute];
}

- (NSArray *)windows {
	return [self wrappedAttributeForKey:NSAccessibilityWindowsAttribute];
}

@end
