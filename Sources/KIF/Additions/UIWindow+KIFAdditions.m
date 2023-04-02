//
//  UIWindow+KIFAdditions.m
//  KIF
//
//  Created by Steve Sun on 2023-04-02.
//

#import "UIWindow+KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import <objc/runtime.h>

@implementation UIWindow (KIFAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(becomeKeyWindow);
        SEL swizzledSelector = @selector(swizzle_becomeKeyWindow);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)swizzle_becomeKeyWindow
{
    [self swizzle_becomeKeyWindow];
    self.layer.speed = [UIApplication sharedApplication].animationSpeed;
}

@end
