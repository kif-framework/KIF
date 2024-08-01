//
//  UIAccessibilityCustomAction+KIFAdditions.h
//  KIF
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <UIKit/UIKit.h>

@interface NSObject (KIFCustomActionAdditions)

- (UIAccessibilityCustomAction *)KIF_customActionWithName:(NSString *)name;

@end

@interface UIAccessibilityCustomAction (KIFAdditions)

- (BOOL)KIF_activate;

@end

