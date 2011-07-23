//
//  KIFElement.m
//  Temperature
//
//  Created by Josh Abernathy on 7/16/11.
//  Copyright 2011 Maybe Apps, LLC. All rights reserved.
//

#import "KIFElement.h"
#import "KIFElement+Private.h"

@interface KIFElement ()
@property (nonatomic, assign) AXUIElementRef elementRef;
@end


@implementation KIFElement

- (void)dealloc {
	if(self.elementRef != NULL) {
		CFRelease(self.elementRef);
		self.elementRef = NULL;
	}
	
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p> identifier: %@, role: %@, subrole: %@", NSStringFromClass([self class]), self, self.identifier, self.role, self.subrole];
}


#pragma mark API

@synthesize elementRef;

+ (KIFElement *)elementWithElementRef:(AXUIElementRef)elementRef {
	return [[[self alloc] initWithElementRef:elementRef] autorelease];
}

- (id)initWithElementRef:(AXUIElementRef)ref {
	NSParameterAssert(ref != NULL);
	
	self = [super init];
	if(self == nil) return nil;
	
	self.elementRef = CFRetain(ref);
	
	return self;
}

- (KIFElement *)childWithIdentifier:(NSString *)identifier {
	NSMutableArray *parentsToInvestigate = [NSMutableArray array];
	[parentsToInvestigate addObject:self];
	
	while(parentsToInvestigate.count > 0) {
		NSMutableArray *nextSetOfParents = [NSMutableArray array];
		for(KIFElement *parent in parentsToInvestigate) {
			KIFElement *match = [parent immediateChildWithIdentifier:identifier];
			if(match != nil) {
				return match;
			} else {
				[nextSetOfParents addObjectsFromArray:parent.children];
			}
		}
		
		parentsToInvestigate = nextSetOfParents;
	}
	
	return nil;
}

- (KIFElement *)immediateChildWithIdentifier:(NSString *)identifier {
	NSLog(@"%@, %@", self.children, identifier);
	for(KIFElement *child in self.children) {
		if([child.identifier isEqualToString:identifier]) {
			return child;
		}
	}
	
	return nil;
}

- (KIFElement *)childWithPath:(NSString *)identifierPath {
	NSArray *elementIdentifiers = [identifierPath componentsSeparatedByString:@"/"];
	KIFElement *currentElement = self;
	for(NSString *identifier in elementIdentifiers) {
		currentElement = [currentElement immediateChildWithIdentifier:identifier];
		if(currentElement == nil) break;
	}
	
	return nil;
}

- (void)performPressAction {
	AXUIElementPerformAction(self.elementRef, (CFStringRef) NSAccessibilityPressAction);
}

- (KIFElement *)window {
	return [self wrappedAttributeForKey:NSAccessibilityWindowAttribute];
}

- (KIFElement *)topLevelUIElement {
	return [self wrappedAttributeForKey:NSAccessibilityTopLevelUIElementAttribute];
}

- (NSArray *)children {
	return [self wrappedAttributeForKey:NSAccessibilityChildrenAttribute];
}

- (KIFElement *)parent {
	return [self wrappedAttributeForKey:NSAccessibilityParentAttribute];
}

- (NSString *)role {
	return (NSString *) [self attributeForKey:NSAccessibilityRoleAttribute];
}

- (NSString *)subrole {
	return (NSString *) [self attributeForKey:NSAccessibilitySubroleAttribute];
}

- (NSString *)identifier {
	return (NSString *) [self attributeForKey:NSAccessibilityIdentifierAttribute];
}

- (NSString *)title {
	return (NSString *) [self attributeForKey:NSAccessibilityTitleAttribute];
}

- (NSString *)value {
	return (NSString *) [self attributeForKey:NSAccessibilityValueAttribute];
}

- (NSRect)frame {
	NSPoint origin = [(NSValue *) [self attributeForKey:NSAccessibilityPositionAttribute] pointValue];
	NSSize size = [(NSValue *) [self attributeForKey:NSAccessibilitySizeAttribute] sizeValue];
	return NSMakeRect(origin.x, origin.y, size.width, size.height);
}

@end
