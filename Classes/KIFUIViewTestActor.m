//
//  KIFUIViewActor.m
//  KIF
//
//  Created by Alex Odawa on 1/21/15.
//
//

#import "KIFUIViewTestActor.h"
#import "UIWindow-KIFAdditions.h"


@interface KIFTestActor (PrivateInit)
- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
@end


@interface KIFUIViewTestActor ()

@property (nonatomic, strong) KIFUITestActor *actor;
@property (nonatomic, strong, readwrite) NSPredicate *predicate;

@end


@implementation KIFUIViewTestActor

#pragma mark - Initialization

- (instancetype)initWithFile:(NSString *)file line:(NSInteger)line delegate:(id<KIFTestActorDelegate>)delegate;
{
    self = [super initWithFile:file line:line delegate:delegate];
    if (self) {
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

- (instancetype)usingLabel:(NSString *)label;
{
    int os = [UIDevice currentDevice].systemVersion.intValue;

    if ([label rangeOfString:@"\n"].location == NSNotFound || os == 6) {
        return [self usingPredicateWithFormat:@"accessibilityLabel == %@", label];
    }

    // On iOS 6 the accessibility label may contain line breaks, so when trying to find the
    // element, these line breaks are necessary. But on iOS 7 the system replaces them with
    // spaces. So the same test breaks on either iOS 6 or iOS 7. iOS8 befuddles this again by
    // limiting replacement to spaces in between strings.
    // UNLESS the accessibility label is set programatically in which case the line breaks remain regardless of os version.
    // To work around this replace the line breaks and try matching both.

    //this feels horribly hacky and looks bad in our - (NSString *)description :( but tests are passing
    // We might consider replaceing the predicate with a block that can do cleaner checking,

    NSString *alternate = nil;
    if (os == 7) {
        alternate = [label stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    } else {
        alternate = [label stringByReplacingOccurrencesOfString:@"\\b\\n\\b" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, label.length)];
    }

    return [self usingPredicateWithFormat:@"accessibilityLabel == %@ OR accessibilityLabel == %@", label, alternate];
}

- (instancetype)usingIdentifier:(NSString *)identifier;
{
    return [self usingPredicateWithFormat:@"accessibilityIdentifier == %@", identifier];
}

- (instancetype)usingTraits:(UIAccessibilityTraits)traits;
{
    return [self usingPredicateWithFormat:@"(accessibilityTraits & %i) == %i", traits, traits];
}

- (instancetype)usingValue:(NSString *)value;
{
    return [self usingPredicateWithFormat:@"accessibilityValue like %@", value];
}

#pragma mark -

- (NSString *)description;
{
    KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
    return [NSString stringWithFormat:@"<%@; view=%@; element=%@; predicate=%@>", [super description], found.view, found.element, self.predicate];
}

- (void)acknowledgeSystemAlert;
{
    [self.actor acknowledgeSystemAlert];
}

#pragma mark - Waiting

- (void)waitForView;
{
    [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
}

- (void)waitForAbsenceOfView;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        // If the app is ignoring interaction events, then wait before doing our analysis
        KIFTestWaitCondition(![[UIApplication sharedApplication] isIgnoringInteractionEvents], error, @"Application is ignoring interaction events.");
        
        // If the element can't be found, then we're done
        KIFUIObject *found = [self _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
        if (!found) {
            return KIFTestStepResultSuccess;
        }
        
        // If we found an element, but it's not associated with a view, then something's wrong. Wait it out and try again.
        KIFTestWaitCondition(found.view, error, @"Cannot find view containing accessibility element \"%@\"", found.element);
        
        // Hidden views count as absent
        KIFTestWaitCondition([found.view isHidden] || [found.view superview] == nil, error, @"Accessibility element \"%@\" is visible and not hidden.", found);
        
        return KIFTestStepResultSuccess;
    }];
}

- (void)waitToBecomeTappable;
{
    [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
}

- (void)waitToBecomeFirstResponder;
{
    [self runBlock:^KIFTestStepResult(NSError **error) {
        UIResponder *firstResponder = [[[UIApplication sharedApplication] keyWindow] firstResponder];

        KIFTestWaitCondition([self.predicate evaluateWithObject:firstResponder], error, @"Expected first responder to match '%@', got '%@'", self.predicate, firstResponder);
        return KIFTestStepResultSuccess;
    }];
}

- (BOOL)tryFindingView;
{
    return [self _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
}

- (BOOL)tryFindingTappableView;
{
    return [self _predicateSearchWithRequiresMatch:NO mustBeTappable:YES];
}


#pragma mark - Tap Actions

- (void)tap;
{
    KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
    [self.actor tapAccessibilityElement:found.element inView:found.view];
}

- (void)longPress;
{
    [self longPressWithDuration:.5];
}

- (void)longPressWithDuration:(NSTimeInterval)duration;
{
    KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:YES];
    [self.actor longPressAccessibilityElement:found.element inView:found.view duration:duration];
}

- (void)tapScreenAtPoint:(CGPoint)screenPoint;
{
    [self.actor tapScreenAtPoint:screenPoint];
}

#pragma mark - Text Actions;

- (void)clearText;
{
    KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
    [self.actor clearTextFromElement:found.element inView:found.view];
}

- (void)enterText:(NSString *)text;
{
    [self enterText:text expectedResult:nil];
}

- (void)enterText:(NSString *)text expectedResult:(NSString *)expectedResult;
{
    KIFUIObject *found = [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO];
    [self.actor enterText:text intoElement:found.element inView:found.view expectedResult:expectedResult];
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
- (void)enterTextIntoCurrentFirstResponder:(NSString *)text;
{
    [self.actor enterTextIntoCurrentFirstResponder:text];
}


#pragma mark - Getters

- (UIView *)view;
{
    return [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO].view;
}

- (UIAccessibilityElement *)element;
{
    return [self _predicateSearchWithRequiresMatch:YES mustBeTappable:NO].element;
}

- (BOOL)hasMatch;
{
    return [self _predicateSearchWithRequiresMatch:NO mustBeTappable:NO];
}


#pragma mark - Private Methods

- (void)_appendPredicate:(NSPredicate *)newPredicate;
{
    if (!self.predicate) {
        self.predicate = newPredicate;
    } else {
        NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[ self.predicate, newPredicate ]];
        self.predicate = compoundPredicate;
    }
}

- (KIFUIObject *)_predicateSearchWithRequiresMatch:(BOOL)requiresMatch mustBeTappable:(BOOL)tappable;
{
    UIView *foundView = nil;
    UIAccessibilityElement *foundElement = nil;

    [self.actor usingTimeout:self.executionBlockTimeout];
    if (requiresMatch) {
        [self.actor waitForAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable];
    } else {
        [self.actor tryFindingAccessibilityElement:&foundElement view:&foundView withElementMatchingPredicate:self.predicate tappable:tappable error:nil];
    }

    if (foundView && foundElement) {
        return [[KIFUIObject alloc] initWithElement:foundElement view:foundView];
    }
    return nil;
}

@end
