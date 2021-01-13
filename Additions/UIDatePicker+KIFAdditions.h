#import <UIKit/UIKit.h>

@interface UIDatePicker (KIFAdditions)

// Selects the date and emits the value changed event.
// NOTE: only works for non countdown timer date pickers.
- (void)selectDate:(NSDate *)date;

// Selects the hour and minutes in the countdown timer and emits the value changed event.
// NOTE: only works for countdown timer date pickers.
- (void)selectCountdownHours:(NSUInteger)hours minutes:(NSUInteger)minutes;

@end
