#import "KIFRunLoop.h"

SInt32 KIFRunLoopRunInMode(CFStringRef mode, CFTimeInterval seconds, Boolean returnAfterSourceHandled) {
  SInt32 result;
    @autoreleasepool {
        result = CFRunLoopRunInMode(mode, seconds, returnAfterSourceHandled);
    }
    return result;
}
