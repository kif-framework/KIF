//
//  NSPredicate+KIFAdditions.m
//  KIF
//
//  Created by Alex Odawa on 2/3/15.
//
//

#import "NSCompoundPredicate+KIFAdditions.h"


@implementation NSCompoundPredicate (KIFAdditions)

- (NSArray *)decomposedSubpredicates;
{
    NSMutableArray *decomposed = [NSMutableArray array];
    
    for (NSPredicate *predicate in self.subpredicates) {
        if (![predicate isKindOfClass:[NSCompoundPredicate class]]) {
            [decomposed addObject:predicate];
        }
        else {
            [decomposed addObjectsFromArray:[(NSCompoundPredicate*)predicate decomposedSubpredicates]];
        }
    }
    return [decomposed copy];
}

@end
