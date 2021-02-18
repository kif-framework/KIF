#import <Foundation/Foundation.h>

@interface KIFEventVisualizer : NSObject

+ (nonnull instancetype)sharedVisualizer;

- (void)visualizeEvent:(nonnull UIEvent *)event;

// Unavailable.
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;


@end
