//
//  KIFTypist.m
//  KIF
//
//  Created by Pete Hodgson on 8/12/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTypist.h"
#import "UIApplication-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"

static NSTimeInterval keystrokeDelay = 0.1f;

@interface KIFTypist()
@property (nonatomic, assign) BOOL keyboardHidden;
+ (NSString *)_representedKeyboardStringForCharacter:(NSString *)characterString;
+ (BOOL)_enterCharacter:(NSString *)characterString history:(NSMutableDictionary *)history;
+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;
@end

@implementation KIFTypist

+ (KIFTypist *)sharedTypist
{
    static dispatch_once_t once;
    static KIFTypist *sharedObserver = nil;
    dispatch_once(&once, ^{
        sharedObserver = [[self alloc] init];
    });
    return sharedObserver;
}

+ (void)registerForNotifications {
    [[self sharedTypist] registerForNotifications];
}

- (instancetype)init
{
    if ((self = [super init])) {
        self.keyboardHidden = YES;
    }
    return self;
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShowNotification:(NSNotification *)notification
{
    self.keyboardHidden = NO;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    self.keyboardHidden = YES;
}

+ (BOOL)keyboardHidden
{
    return [self sharedTypist].keyboardHidden;
}

+ (NSString *)_representedKeyboardStringForCharacter:(NSString *)characterString;
{
    // Interpret control characters appropriately
    if ([characterString isEqual:@"\b"]) {
        characterString = @"Delete";
    }
    
    return characterString;
}

+ (BOOL)enterCharacter:(NSString *)characterString;
{
    return [self _enterCharacter:characterString history:[NSMutableDictionary dictionary]];
}

+ (BOOL)_enterCharacter:(NSString *)characterString history:(NSMutableDictionary *)history;
{
    // Each key on the keyboard does not have its own view, so we have to ask for the list of keys,
    // find the appropriate one, and tap inside the frame of that key on the main keyboard view.
    if (!characterString.length) {
        return YES;
    }
    
    UIWindow *keyboardWindow = [[UIApplication sharedApplication] keyboardWindow];
    UIView *keyboardView = [[keyboardWindow subviewsWithClassNamePrefix:@"UIKBKeyplaneView"] lastObject];
    
    // If we didn't find the standard keyboard view, then we may have a custom keyboard
    if (!keyboardView) {
        return [self _enterCustomKeyboardCharacter:characterString];
    }
    id /*UIKBKeyplane*/ keyplane = [keyboardView valueForKey:@"keyplane"];
    BOOL isShiftKeyplane = [[keyplane valueForKey:@"isShiftKeyplane"] boolValue];
    
    NSValue *keyplaneValue = [NSValue valueWithNonretainedObject:keyplane];
    
    NSMutableArray *unvisitedForKeyplane = [history objectForKey:keyplaneValue];
    if (!unvisitedForKeyplane) {
        unvisitedForKeyplane = [NSMutableArray arrayWithObjects:@"More", @"International", nil];
        if (!isShiftKeyplane) {
            [unvisitedForKeyplane insertObject:@"Shift" atIndex:0];
        }
        [history setObject:unvisitedForKeyplane forKey:keyplaneValue];
    }
    
    NSArray *keys = [keyplane valueForKey:@"keys"];
    
    // Interpret control characters appropriately
    characterString = [self _representedKeyboardStringForCharacter:characterString];
    
    id keyToTap = nil;
    id modifierKey = nil;
    NSString *selectedModifierRepresentedString = nil;
    
    while (YES) {
        for (id/*UIKBKey*/ key in keys) {
            NSString *representedString = [key valueForKey:@"representedString"];
            
            // Find the key based on the key's represented string
            if ([representedString isEqual:characterString]) {
                keyToTap = key;
            }
            
            if (!modifierKey && unvisitedForKeyplane.count && [[unvisitedForKeyplane objectAtIndex:0] isEqual:representedString]) {
                modifierKey = key;
                selectedModifierRepresentedString = representedString;
                [unvisitedForKeyplane removeObjectAtIndex:0];
            }
        }
        
        if (keyToTap) {
            break;
        }
        
        if (modifierKey) {
            break;
        }
        
        if (!unvisitedForKeyplane.count) {
            return NO;
        }
        
        // If we didn't find the key or the modifier, then this modifier must not exist on this keyboard. Remove it.
        [unvisitedForKeyplane removeObjectAtIndex:0];
    }
    
    if (keyToTap) {
        [keyboardView tapAtPoint:CGPointCenteredInRect([keyToTap frame])];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
        
        return YES;
    }
    
    // We didn't find anything, so try the symbols pane
    if (modifierKey) {
        [keyboardView tapAtPoint:CGPointCenteredInRect([modifierKey frame])];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
        
        // If we're back at a place we've been before, and we still have things to explore in the previous
        id /*UIKBKeyplane*/ newKeyplane = [keyboardView valueForKey:@"keyplane"];
        id /*UIKBKeyplane*/ previousKeyplane = [history valueForKey:@"previousKeyplane"];
        
        if (newKeyplane == previousKeyplane) {
            // Come back to the keyplane that we just tested so that we can try the other modifiers
            NSValue *keyplaneValue = [NSValue valueWithNonretainedObject:newKeyplane];
            NSMutableArray *previousKeyplaneHistory = [history objectForKey:keyplaneValue];
            [previousKeyplaneHistory insertObject:[history valueForKey:@"lastModifierRepresentedString"] atIndex:0];
        } else {
            [history setValue:keyplane forKey:@"previousKeyplane"];
            [history setValue:selectedModifierRepresentedString forKey:@"lastModifierRepresentedString"];
        }
        
        return [self _enterCharacter:characterString history:history];
    }
    
    return NO;
}

+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;
{
    if (!characterString.length) {
        return YES;
    }
    
    characterString = [self _representedKeyboardStringForCharacter:characterString];
    
    // For custom keyboards, use the classic methods of looking up views based on accessibility labels
    UIWindow *keyboardWindow = [[UIApplication sharedApplication] keyboardWindow];
    
    UIAccessibilityElement *element = [keyboardWindow accessibilityElementWithLabel:characterString];
    if (!element) {
        return NO;
    }
    
    UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
    CGRect keyFrame = [view.windowOrIdentityWindow convertRect:[element accessibilityFrame] toView:view];
    [view tapAtPoint:CGPointCenteredInRect(keyFrame)];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, keystrokeDelay, false);
    
    return YES;
}

+ (void)setKeystrokeDelay:(NSTimeInterval)delay
{
    keystrokeDelay = delay;
}

@end
