#import "KIFTouchVisualizerView.h"

static CGFloat KIFVisualizerCircleViewDiameter = 40.0;

@interface KIFTouchVisualizerView()
@end

@implementation KIFTouchVisualizerView

- (instancetype)initWithCenter:(CGPoint)center
{
    CGFloat radius = KIFVisualizerCircleViewDiameter / 2.0;
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, KIFVisualizerCircleViewDiameter, KIFVisualizerCircleViewDiameter)];
    self.backgroundColor = [[UIColor alloc] initWithRed:175.0/255.0 green:82.0/255.0 blue:222.0/255.0 alpha:0.5];
    self.layer.borderWidth = 3.0;
    self.layer.borderColor = [[[UIColor alloc] initWithRed:175.0/255.0 green:82.0/255.0 blue:222.0/255.0 alpha:0.9] CGColor];
    self.layer.cornerRadius = radius;
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return nil;
}

@end
