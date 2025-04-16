#import "NSObject+KIFAdditions.h"

@implementation NSObject (KIFAdditions)

- (BOOL)isAccessibilityAdjustable {
    return (self.accessibilityTraits & UIAccessibilityTraitAdjustable) != 0;
}

@end
