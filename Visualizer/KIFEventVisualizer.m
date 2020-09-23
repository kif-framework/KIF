#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "KIFEventVisualizer.h"
#import "KIFTouchVisualizerViewCoordinator.h"

static BOOL __isKIFVisualizerCreated = NO;

@interface KIFEventVisualizerWindow : UIWindow
@end

@implementation KIFEventVisualizerWindow

- (UIWindowLevel)windowLevel
{
    return 100000099;
}

@end

@interface KIFEventVisualizer()

@property (strong, nonatomic, readonly) KIFTouchVisualizerViewCoordinator *coordinator;

@end

@implementation KIFEventVisualizer

+ (BOOL)isVisualizerCreated
{
    return __isKIFVisualizerCreated;
}

+ (instancetype)sharedVisualizer
{
    static dispatch_once_t onceToken;
    static KIFEventVisualizer *sharedVisualizer = nil;
    dispatch_once(&onceToken, ^{
        sharedVisualizer = [[KIFEventVisualizer alloc] initPrivate];
        __isKIFVisualizerCreated = YES;
    });
    
    return sharedVisualizer;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    _window = [[KIFEventVisualizerWindow alloc] init];
    _window.userInteractionEnabled = NO;
    _window.hidden = NO;
    _window.backgroundColor = UIColor.clearColor;
    _coordinator = [[KIFTouchVisualizerViewCoordinator alloc] initWithView:_window];
    
    return self;
}

- (void)visualizeEvent:(UIEvent *)event
{
    // Currently only support touch events, ignore all others.
    if(event.type != UIEventTypeTouches) {
        return;
    }
    
    static BOOL shouldVisualizeTouches;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *shouldVisualizeTouchesValue = [NSProcessInfo.processInfo.environment objectForKey:@"VISUALIZE_TOUCHES"];
        shouldVisualizeTouches = [[shouldVisualizeTouchesValue uppercaseString] isEqualToString:@"YES"];
    });
    
    // Don't visualize touches unless explicitly told to.
    if(!shouldVisualizeTouches) {
        return;
    }

    for (UITouch *touch in event.allTouches) {
        switch (touch.phase) {
            case UITouchPhaseBegan:
                [self.coordinator touchStarted:touch];
                break;
                
            case UITouchPhaseMoved:
                [self.coordinator touchMoved:touch];
                break;
                              
            case UITouchPhaseCancelled:
            case UITouchPhaseEnded:
                [self.coordinator touchEnded:touch];
                break;

            default:
                break;
        }
    }
}

@end

