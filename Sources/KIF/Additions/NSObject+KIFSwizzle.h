//
//  NSObject+KIFSwizzle.h
//  KIF
//
//  Created by Steve Sun on 2023-04-03.
//

#import <Foundation/Foundation.h>

@interface NSObject (KIFSwizzle)

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL;

@end
