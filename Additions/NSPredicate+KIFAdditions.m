//
//  NSPredicate+KIFAdditions.m
//  KIF
//
//  Created by Alex Odawa on 2/3/15.
//
//

#import "NSPredicate+KIFAdditions.h"

@implementation NSPredicate (KIFAdditions)

- (NSArray *)flatten
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if ([self isKindOfClass:[NSCompoundPredicate class]]) {
        for (NSPredicate *predicate in ((NSCompoundPredicate *)self).subpredicates) {
            [result addObjectsFromArray:[predicate flatten]];
        }
    } else {
        [result addObject:self];
    }
    
    return result;
}

- (NSCompoundPredicate *)minusSubpredicatesFrom:(NSPredicate *)otherPredicate;
{
    if (self == otherPredicate) {
        return nil;
    }
    NSMutableSet *subpredicates = [NSMutableSet setWithArray:[self flatten]];
    NSMutableSet *otherSubpredicates = [NSMutableSet setWithArray:[otherPredicate flatten]];
    [subpredicates minusSet:otherSubpredicates];
    return [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                       subpredicates:[subpredicates allObjects]];
}

@end
