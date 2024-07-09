//
//  UIAccessibilityCustomAction+KIFAdditions.m
//  KIF Tests
//
//  Created by Alex Odawa on 09/07/2024.
//

#import <UIKit/UIKit.h>

@implementation UIAccessibilityCustomAction (KIFAdditions)

- (BOOL)activate;
{
    if (@available(iOS 13.0, *)) {
        if (self.actionHandler && self.actionHandler(self)) {
            return YES;
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
    return NO;
}

@end
