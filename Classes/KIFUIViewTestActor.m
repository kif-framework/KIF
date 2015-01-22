//
//  KIFUIViewActor.m
//  KIF
//
//  Created by Alex Odawa on 1/21/15.
//
//

#import "KIFUIViewTestActor.h"

@interface KIFTestActor (privateInit)
- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
@end


@interface KIFUIViewTestActor ()

@property (nonatomic, strong) KIFUITestActor *actor;

@property (nonatomic, weak, readwrite) UIView *view;
@property (nonatomic, weak, readwrite) UIAccessibilityElement *element;
@property (nonatomic, strong, readwrite) NSPredicate *predicate;

@end


@implementation KIFUIViewTestActor

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
{
    self = [super initWithFile:file line:line delegate:delegate];
    if (self)
    {
        _actor = [KIFUITestActor actorInFile:self.file atLine:self.line delegate:self.delegate];
        _view = nil;
        _element = nil;
        _predicate = nil;
    }
    return self;
}

- (instancetype)usingPredicateWithFormat:(NSString *)predicateFormat, ...;
{
    va_list args;
    va_start(args, predicateFormat);
    self.predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:args];
    va_end(args);
    return self;
}

- (instancetype)usingAccessibilityLabel:(NSString *)label;
{
    return [self usingPredicateWithFormat:@"accessibilityLabel = %@", label];
}

- (instancetype)usingAccessibilityIdentifier:(NSString* )identifier;
{
    return [self usingPredicateWithFormat:@"accessibilityIdentifier = %@", identifier];
}

- (void)invalidate;
{
    self.view = nil;
    self.element = nil;
}
#pragma mark - Actions

- (void)tap;
{
    [self.actor tapAccessibilityElement:self.element inView:self.view];
}

- (void)longPressWithDuration:(NSTimeInterval)duration;
{
    [self.actor longPressAccessibilityElement:self.element inView:self.view duration:duration];
}

#pragma mark - Getters

- (UIView *)view;
{
    if (!_view) {
        [self _predicateSearchWithRequiresMatch:YES];
    }
    return _view;
}

- (UIAccessibilityElement *)element;
{
    if (!_element) {
        [self _predicateSearchWithRequiresMatch:YES];
    }
    return _element;
}

- (BOOL)hasMatch;
{
    if (!_view) {
        [self _predicateSearchWithRequiresMatch:NO];
    }
    return _view;
}

#pragma mark - Private Methods

- (void)_predicateSearchWithRequiresMatch:(BOOL)requiresMatch;
{
    UIView *foundView = nil;
    UIAccessibilityElement *foundElement = nil;
    
    [self.actor usingTimeout:self.executionBlockTimeout];
    if (requiresMatch) {
        [self.actor waitForAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:NO];
    } else {
        [self.actor tryFindingAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:NO error:nil];
    }
 
    _view = foundView;
    _element = foundElement;
}

@end
