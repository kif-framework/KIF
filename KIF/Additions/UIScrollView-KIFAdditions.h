//
//  UIScrollView-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/22/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIScrollView (KIFAdditions)

- (void)scrollViewToVisible:(UIView *)view animated:(BOOL)animated;

@end
