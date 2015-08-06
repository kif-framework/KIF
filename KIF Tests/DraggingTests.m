//
//  DraggingTests.m
//  KIF
//
//  Created by Michael Lupo on 6/12/15.
//
//

#import <KIF/KIF.h>
#import <KIF/UIView-KIFAdditions.h>
#import "KIF/KIFUITestActor.h"

@interface DraggingTests : KIFTestCase
@end

@implementation DraggingTests

- (void)beforeEach
{
	[tester tapViewWithAccessibilityLabel:@"Dragging"];
}

- (void)afterEach
{
	[tester tapViewWithAccessibilityLabel:@"Test Suite" traits:UIAccessibilityTraitButton];
}

- (void)testDragging
{
	UIView *bananaView = [tester waitForViewWithAccessibilityLabel:@"bananas"];

	CGPoint stepperPointToTap;
	@autoreleasepool {
		UIView *view = nil;
		UIAccessibilityElement *element = nil;
		[tester waitForAccessibilityElement:&element view:&view withLabel:@"bananas" value:nil traits:UIAccessibilityTraitNone tappable:YES];
		CGRect elementFrame;
		if (CGRectEqualToRect(CGRectZero, element.accessibilityFrame)) {
			elementFrame.origin = CGPointZero;
			elementFrame.size = view.frame.size;
		} else {
			elementFrame = [view.windowOrIdentityWindow convertRect:element.accessibilityFrame toView:view];
		}

		stepperPointToTap = [bananaView tappablePointInRect:elementFrame];
		stepperPointToTap = [bananaView convertPoint:stepperPointToTap toView:nil];
	}

	[system waitForNotificationName:@"draggingEnded" object:nil whileExecutingBlock:^{
		[tester longPressAndDragViewWithAccessibilityLabel:@"monkey" toPoint:stepperPointToTap steps:100];
	}];
}

@end

