//
//  UIWindow+KIFAdditions.m
//  KIF
//
//  Created by Steve Sun on 2023-04-02.
//

#import "UIWindow+KIFSwizzle.h"
#import "UIApplication-KIFAdditions.h"
#import "NSObject+KIFSwizzle.h"

@interface UIWindow ()

- (instancetype)_initWithFrame:(CGRect)rect debugName:(NSString *)debugName windowScene:(UIWindowScene *)windowScene API_AVAILABLE(ios(13));

@end


@implementation UIWindow (KIFSwizzle)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13, *)) {
            [self swizzleSEL:@selector(_initWithFrame:debugName:windowScene:) withSEL:@selector(swizzle__initWithFrame:debugName:windowScene:)];
        } else {
            [self swizzleSEL:@selector(init) withSEL:@selector(swizzle_init)];
        }
        [self swizzleSEL:@selector(becomeKeyWindow) withSEL:@selector(swizzle_becomeKeyWindow)];
    });
}

- (instancetype)swizzle__initWithFrame:(CGRect)rect debugName:(NSString *)debugName windowScene:(UIWindowScene *)windowScene API_AVAILABLE(ios(13))
{
    UIWindow *window = [self swizzle__initWithFrame:rect debugName:debugName windowScene:windowScene];
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
