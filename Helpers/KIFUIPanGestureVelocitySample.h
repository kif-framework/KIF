//
//  KIFUIPanGestureVelocitySample.h
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KIFUIPanGestureVelocitySample : NSObject
@property(assign) double dt;
@property(assign) CGPoint end;
@property(assign) CGPoint start;
- (id)panGestureVelocitySample;
- (id)initWithPanGestureVelocitySample:(id)panGestureVelocitySample;
@end
