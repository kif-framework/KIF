//
//  UIAccessibilityCustomAction+KIFAdditions.m
//  KIF Tests
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <UIKit/UIKit.h>
#import "UIAccessibilityCustomAction+KIFAdditions.h"

@implementation UIAccessibilityCustomAction (KIFAdditions)

- (BOOL)KIF_activate;
{
    if (@available(iOS 13.0, *)) {
        if (self.actionHandler) {
            return self.actionHandler(self);
        }
    }
    
    if ([self.target respondsToSelector:self.selector]) {
        NSMethodSignature *signature = [self.target methodSignatureForSelector:self.selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = self.selector;
        invocation.target = self.target;
        
        /*
         https://developer.apple.com/documentation/uikit/uiaccessibilitycustomaction/1620499-init
         The method signature must take one of the following forms:
         - (BOOL)myPerformActionMethod
         - (BOOL)myPerformActionMethod:(UIAccessibilityCustomAction *)action
         */
        if (signature.numberOfArguments == 3) {
            id arg = self;
            [invocation setArgument: &arg atIndex:2];
        }
        
        [invocation invoke];
        BOOL returnValue = NO;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    NSString *targetStr = [self.target description];
    NSString *selectorStr = NSStringFromSelector(self.selector);
    [[NSException exceptionWithName:@"KIFUIAccessibilityCustomActionActivationException"
                             reason:@"UIAccessibilityCustomAction Target does not respond to provided Selector."
                           userInfo:@{@"Target" : targetStr, @"Selector" : selectorStr}]
     raise];

    return NO;
}

- (NSString *)KIF_normalizedName;
{
    NSString *name = [self name];
    if ([name isKindOfClass:[NSAttributedString class]]) {
        name = [(NSAttributedString *)name string];
    }
    return name;
}

@end
