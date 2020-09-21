#import <Foundation/Foundation.h>

@interface KIFEventVisualizer : NSObject

+ (BOOL)isVisualizerCreated;
+ (nonnull instancetype)sharedVisualizer;

@property (strong, nonatomic, readonly, nonnull) UIWindow *window;
- (void)visualizeEvent:(nonnull UIEvent *)event;

// Unavailable.
- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;


@end
