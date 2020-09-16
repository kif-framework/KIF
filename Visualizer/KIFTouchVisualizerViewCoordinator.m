#import "KIFTouchVisualizerViewCoordinator.h"
#import "KIFTouchVisualizerView.h"

static const CGFloat KIFTouchAnimationDuration = 0.75;

@interface KIFTouchVisualizerViewCoordinator ()

@property (weak, nonatomic, readonly) UIView *view;
@property (strong, nonatomic, readonly) NSMutableDictionary<NSNumber *, KIFTouchVisualizerView *> *touchToView;

@end

@implementation KIFTouchVisualizerViewCoordinator

- (instancetype)initWithView:(UIWindow *)view
{
    self = [super init];
    
    _view = view;
    _touchToView = [NSMutableDictionary dictionary];
    
    return self;
}

- (void)touchStarted:(nonnull UITouch *)touch
{
    KIFTouchVisualizerView *touchView = [[KIFTouchVisualizerView alloc] initWithCenter:[touch locationInView:self.view]];
    [self.view addSubview:touchView];
    self.touchToView[@(touch.hash)] = touchView;
}

- (void)touchMoved:(nonnull UITouch *)touch
{
    KIFTouchVisualizerView *oldView = self.touchToView[@(touch.hash)];
    self.touchToView[@(touch.hash)] = [[KIFTouchVisualizerView alloc] initWithCenter:[touch locationInView:self.view]];
    [self.view addSubview:self.touchToView[@(touch.hash)]];
    [UIView animateWithDuration:KIFTouchAnimationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        oldView.transform = CGAffineTransformScale(oldView.transform, 0.001, 0.001);
    } completion:^(BOOL finished) {
        if(finished) {
            [oldView removeFromSuperview];
        }
    }];
}

- (void)touchEnded:(nonnull UITouch *)touch
{
    [UIView animateWithDuration:KIFTouchAnimationDuration animations:^{
        self.touchToView[@(touch.hash)].transform = CGAffineTransformScale(self.touchToView[@(touch.hash)].transform, 2, 2);
        self.touchToView[@(touch.hash)].alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished) {
            [self.touchToView[@(touch.hash)] removeFromSuperview];
            self.touchToView[@(touch.hash)] = nil;
        }
    }];
}

@end
