#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KIFTouchVisualizerViewCoordinator : NSObject

// The view that the coordinator is managing with the touches.
- (nonnull instancetype)initWithView:(nonnull UIView *)view NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;

- (void)touchStarted:(nonnull UITouch *)touch;
- (void)touchMoved:(nonnull UITouch *)touch;
- (void)touchEnded:(nonnull UITouch *)touch;

@end
