//
//  KIFUIViewActor.m
//  KIF
//
//  Created by Alex Odawa on 1/21/15.
//
//

#import "KIFUIViewTestActor.h"

@interface KIFTestActor (PrivateInit)
- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
@end


@interface KIFUIViewTestActor ()

@property (nonatomic, strong) KIFUITestActor *actor;

@property (nonatomic, weak, readwrite) UIView *view;
@property (nonatomic, weak, readwrite) UIAccessibilityElement *element;
@property (nonatomic, strong, readwrite) NSPredicate *predicate;

@end


@implementation KIFUIViewTestActor

#pragma mark - Initialization

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
{
    self = [super initWithFile:file line:line delegate:delegate];
    if (self)
    {
        _actor = [KIFUITestActor actorInFile:self.file atLine:self.line delegate:self.delegate];
    }
    return self;
}

- (instancetype)usingPredicateWithFormat:(NSString *)predicateFormat, ...;
{
    va_list args;
    va_start(args, predicateFormat);
    [self _appendPredicate:[NSPredicate predicateWithFormat:predicateFormat arguments:args]];
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

- (instancetype)usingExpectedClass:(Class)expectedClass;
{
    return [self usingPredicateWithFormat:@"class == %@",  expectedClass];
}

#pragma mark - 

- (NSString *)description;
{
    if (![self isValid]) {
        return [NSString stringWithFormat:@"<%@; predicate=%@", [super description], self.predicate];
    }
    return [NSString stringWithFormat:@"<%@; view=%@; element=%@; predicate=%@>", [super description], _view, _element, _predicate];
}

#pragma mark - Waiting

- (void)waitForMatch;
{
    [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
}

- (void)waitToBecomeTappable;
{
    [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
}

#pragma mark - Tap Actions

- (void)tap;
{
    [self.actor tapAccessibilityElement:self.element inView:self.view];
}

- (void)longPress;
{
    [self longPressWithDuration:.5];
}

- (void)longPressWithDuration:(NSTimeInterval)duration;
{
    [self.actor longPressAccessibilityElement:self.element inView:self.view duration:duration];
}

#pragma mark - Text Actions;

- (void)clearText;
{
    [self.actor clearTextFromElement:self.element inView:self.view];
}

- (void)enterText:(NSString *)text;
{
    [self enterText:text expectedResult:nil];
}

- (void)enterText:(NSString *)text expectedResult:(NSString *)expectedResult;
{
    [self.actor enterText:text intoElement:self.element inView:self.view expectedResult:expectedResult];
}

- (void)clearAndEnterText:(NSString *)text;
{
    [self clearAndEnterText:text expectedResult:nil];
}

- (void)clearAndEnterText:(NSString *)text expectedResult:(NSString *)expectedResult;
{
    [self clearText];
    [self enterText:text expectedResult:expectedResult];
}

#pragma mark - Getters

- (UIView *)view;
{
    if (!_view || !_element) {
        [self _predicateSearchWithRequiresMatch:YES mustBeTappable: NO];
    }
    return _view;
}

- (UIAccessibilityElement *)element;
{
    if (!self.isValid) {
        [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
    }
    return _element;
}

- (BOOL)hasMatch;
{
    if (!self.isValid) {
        [self _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
    }
    return (_view && _element);
}

- (BOOL)isValid;
{
    return (_view && _element);
}

#pragma mark - Private Methods

- (void)_appendPredicate:(NSPredicate*)newPredicate;
{
    if (!self.predicate){
        self.predicate = newPredicate;
    } else {
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[self.predicate, newPredicate]];
        self.predicate = compoundPredicate;
    }
}

- (void)_predicateSearchWithRequiresMatch:(BOOL)requiresMatch mustBeTappable:(BOOL)tappable;
{
    UIView *foundView = nil;
    UIAccessibilityElement *foundElement = nil;
    
    [self.actor usingTimeout:self.executionBlockTimeout];
    if (requiresMatch) {
        [self.actor waitForAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable];
    } else {
        [self.actor tryFindingAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable error:nil];
    }
 
    _view = foundView;
    _element = foundElement;
}

@end
