//
//  KIFElement.h
//
//  Created by Josh Abernathy on 7/16/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>


@interface KIFElement : NSObject

+ (KIFElement *)elementWithElementRef:(AXUIElementRef)elementRef;

- (id)initWithElementRef:(AXUIElementRef)ref;

- (KIFElement *)childWithIdentifier:(NSString *)identifier; // breadth-first searches until it finds a match or runs out of children
- (KIFElement *)immediateChildWithIdentifier:(NSString *)identifier; // only searches in the element's immediate children
- (KIFElement *)childWithPath:(NSString *)identifierPath;

- (KIFElement *)childWithTitle:(NSString *)title; // breadth-first searches until it finds a match or runs out of children
- (KIFElement *)immediateChildWithTitle:(NSString *)title; // only searches in the element's immediate children

- (void)performPressAction;

@property (nonatomic, assign, readonly) AXUIElementRef elementRef;
@property (nonatomic, readonly) KIFElement *window;
@property (nonatomic, readonly) KIFElement *topLevelUIElement;
@property (nonatomic, readonly) NSArray *children;
@property (nonatomic, readonly) KIFElement *parent;
@property (nonatomic, readonly) NSString *role;
@property (nonatomic, readonly) NSString *subrole;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *value;
@property (nonatomic, readonly) NSRect frame; // in screen coordinates

@end
