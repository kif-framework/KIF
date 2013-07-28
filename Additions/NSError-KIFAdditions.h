//
//  NSError+KIFAdditions.h
//  KIF
//
//  Created by Brian Nickel on 7/27/13.
//
//

#import <Foundation/Foundation.h>

@interface NSError (KIFAdditions)

+ (instancetype)KIFErrorWithCode:(NSInteger)code underlyingError:(NSError *)underlyingError localizedDescriptionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);
+ (instancetype)KIFErrorWithCode:(NSInteger)code localizedDescriptionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);

@end
