//
//  UITouch+KIFExposers.h
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import <UIKit/UIKit.h>

@interface UITouch (KIFExposers)
- (CGPoint)kif_locationInWindow;
- (void)kif_setLocationInWindow:(CGPoint)point;
- (CGPoint)kif_previousLocationInWindow;
- (void)kif_setPreviousLocationInWindow:(CGPoint)point;
@end
