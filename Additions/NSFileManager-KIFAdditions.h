//
//  NSFileManager-KIFAdditions.h
//  KIF
//
//  Created by Michael Thole on 6/1/11
//  Copyright 2011 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (CCAdditions)

- (NSString *)createUserDirectory:(NSSearchPathDirectory)searchPath;
- (BOOL)recursivelyCreateDirectory:(NSString *)path;

@end
