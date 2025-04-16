#import "NSObject+KIFAdditions.h"

@implementation NSObject (KIFAdditions)

- (BOOL)KIF_isAccessibilityAdjustable {
    return (self.accessibilityTraits & UIAccessibilityTraitAdjustable) != 0;
}

@end
