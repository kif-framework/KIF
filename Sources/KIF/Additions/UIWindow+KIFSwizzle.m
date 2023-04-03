//
//  UIWindow+KIFAdditions.m
//  KIF
//
//  Created by Steve Sun on 2023-04-02.
//

#import "UIWindow+KIFSwizzle.h"
#import "UIApplication-KIFAdditions.h"
#import "NSObject+KIFSwizzle.h"

@implementation UIWindow (KIFSwizzle)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(init) withSEL:@selector(swizzle_init)];
        [self swizzleSEL:@selector(becomeKeyWindow) withSEL:@selector(swizzle_becomeKeyWindow)];
        if (@available(iOS 13.0, *)) {
            [self swizzleSEL:@selector(initWithWindowScene:) withSEL:@selector(swizzle_initWithWindowScene:)];
        }
    });
}

- (instancetype)swizzle_initWithWindowScene:(UIWindowScene *)scene API_AVAILABLE(ios(13))
{
    UIWindow *window = [self swizzle_initWithWindowScene:scene];
    window.layer.speed = [UIApplication sharedApplication].animationSpeed;

    return window;
}

- (instancetype)swizzle_init
{
    UIWindow *window = [self swizzle_init];
    window.layer.speed = [UIApplication sharedApplication].animationSpeed;

    return window;
}

- (void)swizzle_becomeKeyWindow
{
    [self swizzle_becomeKeyWindow];
    self.layer.speed = [UIApplication sharedApplication].animationSpeed;
}

@end
