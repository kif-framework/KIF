//
//  KIFTextInputTraitsOverrides.m
//  KIF
//
//  Created by Harley Cooper on 1/31/18.
//

#import <objc/runtime.h>
#import "KIFTextInputTraitsOverrides.h"

static IMP autocorrectOriginalImp;
static IMP smartDashesOriginalImp;
static IMP smartQuotesOriginalImp;

void KIFSetAutocorrect(BOOL setAutocorrectOn) {
    if(!autocorrectOriginalImp) {
        autocorrectOriginalImp = class_getMethodImplementation([UITextField class], @selector(autocorrectionType));
    }

    IMP autocorrectImp;
    if(setAutocorrectOn) {
        autocorrectImp = autocorrectOriginalImp;
    } else if(!setAutocorrectOn) {
        autocorrectImp = imp_implementationWithBlock(^(UITextField *_self) {
            return UITextAutocorrectionTypeNo;
        });
    }
    struct objc_method_description autocorrectionTypeMethodDescription = protocol_getMethodDescription(@protocol(UITextInputTraits), @selector(autocorrectionType), NO, YES);
    class_replaceMethod([UITextField class], @selector(autocorrectionType), autocorrectImp, autocorrectionTypeMethodDescription.types);
}

void KIFSetSmartDashes(BOOL setSmartDashesOn) {
    // This #ifdef is necessary for versions of Xcode before Xcode 9.
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        if(!smartDashesOriginalImp) {
            smartDashesOriginalImp = class_getMethodImplementation([UITextField class], @selector(smartDashesType));
        }

        IMP smartDashesImp;
        if(setSmartDashesOn) {
            smartDashesImp = smartDashesOriginalImp;
        } else if(!setSmartDashesOn) {
            smartDashesImp = imp_implementationWithBlock(^(UITextField *_self) {
                return UITextSmartDashesTypeNo;
            });
        }
        struct objc_method_description smartDashesTypeMethodDescription = protocol_getMethodDescription(@protocol(UITextInputTraits), @selector(smartDashesType), NO, YES);
        class_replaceMethod([UITextField class], @selector(smartDashesType), smartDashesImp, smartDashesTypeMethodDescription.types);
    }
#endif
}

void KIFSetSmartQuotes(BOOL setSmartQuotesOn) {
    // This #ifdef is necessary for versions of Xcode before Xcode 9.
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        if(!smartQuotesOriginalImp) {
            smartQuotesOriginalImp = class_getMethodImplementation([UITextField class], @selector(smartQuotesType));
        }

        IMP smartQuotesImp;
        if(setSmartQuotesOn) {
            smartQuotesImp = smartQuotesOriginalImp;
        } else if(!setSmartQuotesOn) {
            smartQuotesImp = imp_implementationWithBlock(^(UITextField *_self) {
                return UITextSmartQuotesTypeNo;
            });
        }
        struct objc_method_description smartQuotesMethodDescription = protocol_getMethodDescription(@protocol(UITextInputTraits), @selector(smartQuotesType), NO, YES);
        class_replaceMethod([UITextField class], @selector(smartQuotesType), smartQuotesImp, smartQuotesMethodDescription.types);
    }
#endif

}
