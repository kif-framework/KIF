//
//  NSError+KIFAdditions.m
//  KIF
//
//  Created by Brian Nickel on 7/27/13.
//
//

#import "NSError-KIFAdditions.h"
#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(NSError_KIFAdditions)

@implementation NSError (KIFAdditions)

+ (instancetype)KIFErrorWithCode:(NSInteger)code localizedDescriptionWithFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *description = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
    va_end(args);
    
    return [self errorWithDomain:@"KIFTest" code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}

+ (instancetype)KIFErrorWithCode:(NSInteger)code underlyingError:(NSError *)underlyingError localizedDescriptionWithFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *description = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
    va_end(args);
    
    return [self errorWithDomain:@"KIFTest" code:code userInfo:@{NSLocalizedDescriptionKey: description, NSUnderlyingErrorKey: underlyingError}];
}

@end
