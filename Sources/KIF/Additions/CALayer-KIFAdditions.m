//
//  CALayer-KIFAdditions.m
//  Pods
//
//  Created by Radu Ciobanu on 28/01/2016.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "CALayer-KIFAdditions.h"
#import "CAAnimation+KIFAdditions.h"


@implementation CALayer (KIFAdditions)

- (float)KIF_absoluteSpeed
{
    __block float speed = 1.0f;
    [self performBlockOnAncestorLayers:^(CALayer *layer) {
        speed = speed * layer.speed;
    }];
    return speed;
}

- (BOOL)hasAnimations
{
    __block BOOL result = NO;
    [self performBlockOnDescendentLayers:^(CALayer *layer, BOOL *stop) {
        // explicitly exclude _UIParallaxMotionEffect as it is used in alertviews, and we don't want every alertview to be paused
        // explicitly exclude UITextSelectionViewCaretBlinkAnimation as it is used in textfields, and we don't want every view with textfields to be paused
        BOOL hasAnimation = layer.animationKeys.count != 0 && ![layer.animationKeys containsObject:@"_UIParallaxMotionEffect"] && ![layer.animationKeys containsObject:@"UITextSelectionViewCaretBlinkAnimation"];

        // Ignore the animation of the KIF touch visualizer circle as it does not affect any view behavior
        if ([NSStringFromClass(layer.delegate.class) isEqualToString:@"KIFTouchVisualizerView"]) {
            hasAnimation = NO;
        }

        if (hasAnimation && !layer.hidden) {
            double currentTime = CACurrentMediaTime() * [layer KIF_absoluteSpeed];

            [layer.animationKeys enumerateObjectsUsingBlock:^(NSString *animationKey, NSUInteger idx, BOOL *innerStop) {
                CAAnimation *animation = [layer animationForKey:animationKey];

                double completionTime = [animation KIF_completionTime];

                // Ignore long running animations (> 1 minute duration), as we don't want to wait on them
                if (completionTime > currentTime + 60) {
                    return;
                }

                // If an animation is set to be removed on completion, it must still be in progress if we enumerated it
                // This is the default behavior for animations, so we should often hit this codepath.
                if ([animation isRemovedOnCompletion]) {
                    result = YES;
                } else if ([animation.delegate isKindOfClass:NSClassFromString(@"UIViewAnimationState")]) {
                    // Use a private property on the private class to determine if the animation state has completed
                    BOOL animationDidStopSent = [[(NSObject *)animation.delegate valueForKey:@"_animationDidStopSent"] boolValue];

                    if (!animationDidStopSent) {
                        result = YES;
                    }
                } else if (currentTime > completionTime) {
                    // Otherwise, use the completion time to determine if the animation has been completed.
                    // This doesn't seem to always be exactly right however.
                    result = YES;
                }

                if (result) {
                    *innerStop = YES;
                    *stop = YES;
                }
            }];
        }
    }];
    return result;
}

- (void)performBlockOnDescendentLayers:(void (^)(CALayer *layer, BOOL *stop))block
{
    BOOL stop = NO;
    [self performBlockOnDescendentLayers:block stop:&stop];
}

- (void)performBlockOnDescendentLayers:(void (^)(CALayer *, BOOL *))block stop:(BOOL *)stop
{
    if (self.isHidden) {
        return;
    }

    block(self, stop);
    if (*stop) {
        return;
    }

    for (CALayer *layer in self.sublayers.copy) {
        [layer performBlockOnDescendentLayers:block stop:stop];
        if (*stop) {
            return;
        }
    }
}

- (void)performBlockOnAncestorLayers:(void (^)(CALayer *))block;
{
    block(self);

    if (self.superlayer != nil) {
        [self.superlayer performBlockOnAncestorLayers:block];
    }
}

@end
