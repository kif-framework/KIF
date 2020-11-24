#import "UIDatePicker+KIFAdditions.h"
#import "UIDatePicker+KIFPrivateAPI.h"

@implementation UIDatePicker (KIFAdditions)

- (void)selectDate:(NSDate *)date
{
    NSAssert(self.datePickerMode != UIDatePickerModeCountDownTimer, @"Date picker was not in expected date picking mode mode. Instead got countdown timer.");
    self.date = date;
    [self _emitValueChanged];
}

- (void)selectCountdownHours:(NSUInteger)hours minutes:(NSUInteger)minutes
{
    NSAssert(self.datePickerMode == UIDatePickerModeCountDownTimer, @"Date picker was not of type countdown timer.");
    self.countDownDuration = (hours * 60 * 60) + (minutes * 60);
    [self _emitValueChanged];
}

@end
