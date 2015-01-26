//
//  KIFUIObject.m
//  KIF
//
//  Created by Alex Odawa on 1/26/15.
//
//

#import "KIFUIObject.h"
@interface KIFUIObject ()

@property (nonatomic, strong, readwrite) UIView *view;
@property (nonatomic, strong, readwrite) UIAccessibilityElement *element;

@end

@implementation KIFUIObject

- (instancetype)initWithElement:(UIAccessibilityElement *)element view:(UIView *)view;
{
    self = [super init];
    if (self) {
        _element = element;
        _view = view;
    }
    return self;
}
@end
