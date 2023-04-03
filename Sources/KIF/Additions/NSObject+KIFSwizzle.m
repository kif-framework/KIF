//
//  NSObject+KIFSwizzle.m
//  KIF
//
//  Created by Steve Sun on 2023-04-03.
//

#import "NSObject+KIFSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (KIFSwizzle)

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL
{
    Class class = [self class];

    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);

    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end
