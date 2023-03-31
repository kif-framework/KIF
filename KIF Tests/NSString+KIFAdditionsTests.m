//
//  NSString+KIF.h
//  KIF Tests
//
//  Created by Steve Sun on 2023-03-31.
//

#import "NSString+KIFAdditionsTests.h"

@implementation NSString (KIFAdditionsTests)

+ (NSString *)textFieldLongPressSelectText;
{
    if (@available(iOS 16.0, *)) {
        return @"Select";
    } else {
        return @"Select All";
    }
}

@end
