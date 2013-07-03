//
//  NSString+XMLEscapeMethods.m
//  KIF
//
//  Created by Jake Cataford on 7/3/13.
//
//

#import "NSString+XMLEscapeMethods.h"

@implementation NSString (XMLEscapeMethods)

- (NSString *)stringByEscapingStringForXML {
	NSString * result = [[[[[self stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
	stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
	stringByReplacingOccurrencesOfString: @"'" withString: @"&#39;"]
	stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
	stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
	return result;
}

@end
