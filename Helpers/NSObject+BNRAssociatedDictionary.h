//
//  NSObject+BNRAssociatedDictionary.h
//  KIF
//
//  Created by Nate Chandler on 3/27/13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (BNRAssociatedDictionary)

@property (nonatomic, readonly) NSMutableDictionary *bnr_associatedDictionary;

- (id)bnr_associatedObjectForKey:(id<NSCopying>)key;
- (void)bnr_setAssociatedObject:(id)object forKey:(id<NSCopying>)key;

@end
