//
//  KIFTextInputTraitsOverrides.m
//  KIF
//
//  Created by Harley Cooper on 1/31/18.
//

#import <objc/runtime.h>
#import "KIFTextInputTraitsOverrides.h"

@interface KIFTextInputTraitsOverrides()

/*!
 @abstract Swizzles the @c autocorrectionType property of @c UITextField
 @discussion Sets the property to have default behavior when @c allowDefaultAutocorrectBehavior is set to @c YES, and always return @c UITextAutocorrectionTypeNo when it's set to no.
 */
+ (void)KIFSwizzleTextFieldAutocorrect;

/*!
 @abstract Swizzles the @c smartDashesType property of @c UITextField
 @discussion Sets the property to have default behavior when @c allowDefaultSmartDashesBehavior is set to @c YES, and always return @c UITextSmartDashesTypeNo when it's set to no.
 */
+ (void)KIFSwizzleTextFieldSmartDashes;

/*!
 @abstract Swizzles the @c smartQuotesType property of @c UITextField
 @discussion Sets the property to have default behavior when @c allowDefaultSmartQuotesBehavior is set to @c YES, and always return @c UITextSmartQuotesTypeNo when it's set to no.
 */
+ (void)KIFSwizzleTextFieldSmartQuotes;

@end

@implementation KIFTextInputTraitsOverrides

typedef NSInteger (*send_type)(UITextField*, SEL);

static BOOL KIFAutocorrectEnabled = NO;
static BOOL KIFSmartDashesEnabled = NO;
static BOOL KIFSmartQuotesEnabled = NO;

+ (void)load
{
    [self KIFSwizzleTextFieldAutocorrect];
    [self KIFSwizzleTextFieldSmartDashes];
    [self KIFSwizzleTextFieldSmartQuotes];
}

+ (BOOL)allowDefaultAutocorrectBehavior
{
    return KIFAutocorrectEnabled;
}

+ (void)setAllowDefaultAutocorrectBehavior:(BOOL)allowDefaultBehavior
{
    KIFAutocorrectEnabled = allowDefaultBehavior;
}

+ (BOOL)allowDefaultSmartDashesBehavior
{
    return KIFSmartDashesEnabled;
}

+ (void)setAllowDefaultSmartDashesBehavior:(BOOL)allowDefaultBehavior
{
    KIFSmartDashesEnabled = allowDefaultBehavior;
}

+ (BOOL)allowDefaultSmartQuotesBehavior
{
    return KIFSmartQuotesEnabled;
}

+ (void)setAllowDefaultSmartQuotesBehavior:(BOOL)allowDefaultBehavior
{
    KIFSmartQuotesEnabled = allowDefaultBehavior;
}

+ (void)KIFSwizzleTextFieldAutocorrect
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct objc_method_description autocorrectionTypeMethodDescription = protocol_getMethodDescription(@protocol(UITextInputTraits), @selector(autocorrectionType), NO, YES);
        send_type autocorrectOriginalImp = (send_type)[UITextField instanceMethodForSelector:@selector(autocorrectionType)];
        IMP autocorrectImp = imp_implementationWithBlock(^(UITextField *_self) {
            if(self.allowDefaultAutocorrectBehavior) {
                return autocorrectOriginalImp(_self, @selector(autocorrectionType));
            } else {
                return UITextAutocorrectionTypeNo;
            }
        });
        class_replaceMethod([UITextField class], @selector(autocorrectionType), autocorrectImp, autocorrectionTypeMethodDescription.types);
    });
}

+ (void)KIFSwizzleTextFieldSmartDashes
{
    // This #ifdef is necessary for versions of Xcode before Xcode 9.
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            struct objc_method_description smartDashesTypeMethodDescription = protocol_getMethodDescription(@protocol(UITextInputTraits), @selector(smartDashesType), NO, YES);
            send_type smartDashesOriginalImp = (send_type)[UITextField instanceMethodForSelector:@selector(smartDashesType)];
            IMP smartDashesImp = imp_implementationWithBlock(^(UITextField *_self) {
                if(self.allowDefaultSmartDashesBehavior) {
                    return smartDashesOriginalImp(_self, @selector(smartQuotesType));
                } else {
                    return UITextSmartDashesTypeNo;
                }
            });
            class_replaceMethod([UITextField class], @selector(smartDashesType), smartDashesImp, smartDashesTypeMethodDescription.types);
        });
    }
#endif
}

+ (void)KIFSwizzleTextFieldSmartQuotes
{
        // This #ifdef is necessary for versions of Xcode before Xcode 9.
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                struct objc_method_description smartQuotesTypeMethodDescription = protocol_getMethodDescription(@protocol(UITextInputTraits), @selector(smartQuotesType), NO, YES);
                send_type smartQuotesOriginalImp = (send_type)[UITextField instanceMethodForSelector:@selector(smartDashesType)];
                IMP smartQuotesImp = imp_implementationWithBlock(^(UITextField *_self) {
                    if(self.allowDefaultSmartQuotesBehavior) {
                        return smartQuotesOriginalImp(_self, @selector(smartQuotesType));
                    } else {
                        return UITextSmartQuotesTypeNo;
                    }
                });
                class_replaceMethod([UITextField class], @selector(smartQuotesType), smartQuotesImp, smartQuotesTypeMethodDescription.types);
            });
        }
#endif
}

@end
