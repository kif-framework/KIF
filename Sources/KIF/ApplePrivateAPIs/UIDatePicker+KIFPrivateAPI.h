#import <UIKit/UIKit.h>

// Private API's used for UIDatePicker.
@interface UIDatePicker (KIFPrivateAPI)

// After updating the value this is called to inform
// the observers that the value has changed.
- (void)_emitValueChanged;

@end
