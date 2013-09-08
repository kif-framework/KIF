//
//  KIFTypist.m
//  KIF
//
//  Created by Pete Hodgson on 8/12/12.
//
//

#import "KIFTypist.h"
#import "UIApplication-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"

const NSTimeInterval KEYSTROKE_DELAY = 0.05f;

@interface KIFTypist()
+ (NSString *)_representedKeyboardStringForCharacter:(NSString *)characterString;
+ (BOOL)_enterCharacter:(NSString *)characterString history:(NSMutableDictionary *)history;
+ (BOOL)_enterCustomKeyboardCharacter:(NSString *)characterString;
@end

@implementation KIFTypist

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
    [self cancelAnyInitialKeyboardShift];
    return [self _enterCharacter:characterString history:[NSMutableDictionary dictionary]];
}

+ (UIView *)keyboardView{
    UIWindow *keyboardWindow = [[UIApplication sharedApplication] keyboardWindow];
    return [[keyboardWindow subviewsWithClassNamePrefix:@"UIKBKeyplaneView"] lastObject];
}

+ (id /*UIKBKeyplane*/)keyplane {
    return [self.keyboardView valueForKey:@"keyplane"];
}

+ (id /*UIKBKey*/)findKeyNamed:(NSString *)keyName;
{
    id /*UIKBKeyplane*/ keyplane = [self.keyboardView valueForKey:@"keyplane"];
    NSArray *keys = [keyplane valueForKey:@"keys"];

    for (id/*UIKBKey*/ key in keys) {
        NSString *representedString = [key valueForKey:@"representedString"];
        if ([representedString isEqual:keyName]) {
            return key;
        }
    }
    
    return nil;
}

+(void)cancelAnyInitialKeyboardShift
{
    if( [[self.keyplane valueForKey:@"isShiftKeyplane"] boolValue] )
    {
        [self tapKey:[self findKeyNamed:@"Shift"]];
    }
}

+(void)tapKey:(id/*UIKBKey*/)key{
    [self.keyboardView tapAtPoint:CGPointCenteredInRect([key frame])];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, KEYSTROKE_DELAY, false);
}

+ (BOOL)_enterCharacter:(NSString *)characterString history:(NSMutableDictionary *)history;
{
    // Each key on the keyboard does not have its own view, so we have to ask for the list of keys,
    // find the appropriate one, and tap inside the frame of that key on the main keyboard view.
    if (!characterString.length) {
        return YES;
    }
    
    UIView *keyboardView = [self keyboardView];
    
    // If we didn't find the standard keyboard view, then we may have a custom keyboard
    if (!keyboardView) {
        return [self _enterCustomKeyboardCharacter:characterString];
    }
    id /*UIKBKeyplane*/ keyplane = [self keyplane];
    BOOL isShiftKeyplane = [[keyplane valueForKey:@"isShiftKeyplane"] boolValue];
    
    NSMutableArray *unvisitedForKeyplane = [history objectForKey:[NSValue valueWithNonretainedObject:keyplane]];
    if (!unvisitedForKeyplane) {
        unvisitedForKeyplane = [NSMutableArray arrayWithObjects:@"More", @"International", nil];
        if (!isShiftKeyplane) {
            [unvisitedForKeyplane insertObject:@"Shift" atIndex:0];
        }
        [history setObject:unvisitedForKeyplane forKey:[NSValue valueWithNonretainedObject:keyplane]];
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
        [self tapKey:keyToTap];
        return YES;
    }
    
    // We didn't find anything, so try the symbols pane
    if (modifierKey) {
        [self tapKey:modifierKey];
        
        // If we're back at a place we've been before, and we still have things to explore in the previous
        id /*UIKBKeyplane*/ newKeyplane = self.keyplane;
        id /*UIKBKeyplane*/ previousKeyplane = [history valueForKey:@"previousKeyplane"];
        
        if (newKeyplane == previousKeyplane) {
            // Come back to the keyplane that we just tested so that we can try the other modifiers
            NSMutableArray *previousKeyplaneHistory = [history objectForKey:[NSValue valueWithNonretainedObject:newKeyplane]];
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
    CGRect keyFrame = [view.window convertRect:[element accessibilityFrame] toView:view];
    [view tapAtPoint:CGPointCenteredInRect(keyFrame)];
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, KEYSTROKE_DELAY, false);
    
    return YES;
}

@end
