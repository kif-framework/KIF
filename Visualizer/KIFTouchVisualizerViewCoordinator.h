#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KIFTouchVisualizerViewCoordinator : NSObject

- (nonnull instancetype)init;

- (void)touchStarted:(nonnull UITouch *)touch;
- (void)touchMoved:(nonnull UITouch *)touch;
- (void)touchEnded:(nonnull UITouch *)touch;

@end
