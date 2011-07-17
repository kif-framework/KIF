//
//  UITouch-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITouch (KIFAdditions)

- (id)initInView:(UIView *)view;
- (id)initAtPoint:(CGPoint)point inView:(UIView *)view;

- (void)setPhase:(UITouchPhase)phase;

@end
