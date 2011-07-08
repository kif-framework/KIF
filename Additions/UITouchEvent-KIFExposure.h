//
//  UITouchEvent-KIFExposure.h
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIFTouchEvent : NSObject {
@public
    id                      _event;
    NSTimeInterval          _timestamp;
    NSMutableSet           *_touches;
    
    CFMutableDictionaryRef  _keyedTouches;
    CFMutableDictionaryRef  _gestureRecognizersByWindow;
}

- (id)initWithTouch:(UITouch *)touch;
- (BOOL)_addGestureRecognizersForView:(UIView *)view toTouch:(UITouch *)touch;

@end

