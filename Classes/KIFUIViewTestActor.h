//
//  KIFUIViewActor.h
//  KIF
//
//  Created by Alex Odawa on 1/21/15.
//
//

#import <KIF/KIF.h>

#define viewTester KIFActorWithClass(KIFUIViewTestActor)


@interface KIFUIViewTestActor : KIFTestActor 

@property (nonatomic, weak, readonly) UIView *view;
@property (nonatomic, weak, readonly) UIAccessibilityElement *element;
@property (nonatomic, strong, readonly) NSPredicate *predicate;
@property (nonatomic, assign, readonly) BOOL hasMatch;

- (instancetype)usingPredicateWithFormat:(NSString *)predicateFormat, ...;
- (instancetype)usingAccessibilityLabel:(NSString*)label;
- (instancetype)usingAccessibilityIdentifier:(NSString*)identifier;

- (void)tap;
- (void)longPressWithDuration:(NSTimeInterval)duration;
- (void)invalidate;

@end
