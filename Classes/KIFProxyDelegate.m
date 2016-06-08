//
//  KIFProxyDelegate.m
//  KIF
//
//  Created by Ashit Gandhi on 7/24/15.
//
//

#import "KIFProxyDelegate.h"

@interface KIFProxyDelegate ()
@property (nonatomic, weak, readonly) id replacement;
@end

@implementation KIFProxyDelegate

- (instancetype)initWithOriginalDelegate:(NSObject *)original
                     replacementDelegate:(NSObject *)replacement
{
    _original = original;
    _replacement = replacement;
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.replacement respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.replacement];
    }

    if ([self.original respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.original];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (self.original != nil && [self.original respondsToSelector:aSelector]) {
        return [self.original methodSignatureForSelector:aSelector];
    } else {
        return [self.replacement methodSignatureForSelector:aSelector];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [self.original respondsToSelector:aSelector] ||
           [self.replacement respondsToSelector:aSelector];
}

@end
