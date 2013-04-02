//
//  NSObject+BNRIvarConvenience.h
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (BNRIvarConvenience)

- (void *)bnr_ivarPointerForName:(const char *)nameIn;

@end
