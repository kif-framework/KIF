//
//  UIAccessibilityCustomAction+KIFAdditions.h
//  KIF
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <UIKit/UIKit.h>

@interface UIAccessibilityCustomAction (KIFAdditions)

- (BOOL)KIF_activate;

- (NSString *)KIF_normalizedName;

@end

