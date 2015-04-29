//
//  UISegmentedControl+KIFAdditions.m
//  KIF
//
//  Created by Olivier Larivain on 4/15/14.
//
//

#import "UISegmentedControl+KIFAdditions.h"

@implementation UISegmentedControl (KIFAdditions)

- (CGFloat)KIF_widthForSegmentAtIndex:(NSInteger)index
{
	CGFloat autosizedWidth = CGRectGetWidth(self.frame);
	autosizedWidth -= (self.numberOfSegments - 1);
	NSInteger numberOfAutosizedSegmentes = 0;
	NSMutableArray *segmentWidths = [NSMutableArray arrayWithCapacity:self.numberOfSegments];
	for (NSInteger i = 0; i < (NSInteger) self.numberOfSegments; i++) {
		CGFloat width = [self widthForSegmentAtIndex:i];
		if (width == 0.0f) {
			// auto sized
			numberOfAutosizedSegmentes++;
			[segmentWidths addObject:[NSNull null]];
		}
		else {
			// manually sized
			autosizedWidth -= width;
			[segmentWidths addObject:@(width)];
		}
	}
	
	CGFloat autoWidth = floorf(autosizedWidth/(float)numberOfAutosizedSegmentes);
	for (NSInteger i = 0; i < (NSInteger) [segmentWidths count]; i++) {
		id width = [segmentWidths objectAtIndex: i];
		if (width == [NSNull null]) {
			[segmentWidths replaceObjectAtIndex:i withObject:@(autoWidth)];
		}
	}
	
	CGFloat startOffset = 0;
	for (NSInteger i = 0; i < self.selectedSegmentIndex; i++) {
		NSNumber *width = segmentWidths[i];
		startOffset += width.floatValue;
	}
	
	return ((NSNumber *)segmentWidths[self.selectedSegmentIndex]).floatValue;
}

@end
