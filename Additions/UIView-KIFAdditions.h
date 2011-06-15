//
//  UIView-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (KIFAdditions)

@property (nonatomic, readonly, getter=isTappable) BOOL tappable;

- (BOOL)isAncestorOfFirstResponder;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;

- (UIView *)subviewWithClassNamePrefix:(NSString *)prefix;
- (UIView *)subviewWithClassNameOrSuperClassNamePrefix:(NSString *)prefix;

- (void)flash;
- (void)tap;
- (void)tapAtPoint:(CGPoint)point;
- (void)dragFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

/*!
 @method isTappableInRect:
 @abstract Whether or not the receiver can be tapped inside the given rectangular area.
 @discussion Determines whether or not tapping within the given rectangle would actually hit the receiver or one of its children. This is useful for determining if the view is actually on screen and enabled.
 @param rect A rectangle specifying an area in the receiver in the receiver's frame coordinates.
 @result Whether or not the view is tappable.
 */
- (BOOL)isTappableInRect:(CGRect)rect;


- (CGPoint)tappablePointInRect:(CGRect)rect;

@end
