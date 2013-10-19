//
//  UIBarButtonItem+KIFAdditions.m
//  KIF
//
//  Created by Olivier Larivain on 10/18/13.
//
//

#import "UIBarButtonItem+KIFAdditions.h"

@implementation UIBarButtonItem (KIFAdditions)

- (NSString *) accessibilityIdentifier {
	if(self.customView != nil) {
		return self.customView.accessibilityIdentifier;
	}
	
	UIView *view = [self valueForKey: @"view"];
	return view.accessibilityIdentifier;
}

- (void) setAccessibilityIdentifier:(NSString *)accessibilityIdentifier {
	if(self.customView != nil) {
		self.customView.accessibilityIdentifier = accessibilityIdentifier;
		return;
	}
	
	UIView *view = [self valueForKey: @"view"];
	view.accessibilityIdentifier = accessibilityIdentifier;
}

@end
