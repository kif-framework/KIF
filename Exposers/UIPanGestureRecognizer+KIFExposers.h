//
//  UIPanGestureRecognizer+KIFExposers.h
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import <UIKit/UIKit.h>

@class KIFUIPanGestureVelocitySample;

@interface UIPanGestureRecognizer (KIFExposers)

@property (nonatomic) KIFUIPanGestureVelocitySample *velocitySample;
@property (nonatomic) KIFUIPanGestureVelocitySample *previousVelocitySample;

@end
