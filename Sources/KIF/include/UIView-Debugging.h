//
//  UIView+Debugging.h
//  KIF
//
//  Created by Graeme Arthur on 02/05/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Debugging)
/*!
 @abstract Prints a string representation of the view hierarchy via @code+[UIView viewHierarchyDescription]@endcode
 */
+(void)printViewHierarchy;

/*!
 @abstract Prints a string representation of the view hierarchy via @code+[UIView viewHierarchyDescription]@endcode
 */
-(void)printViewHierarchy;

/*!
 @abstract Returns a string representation of the view hierarchy, starting from the top window(s), along with accessibility information, which is more related to KIF than the usual information given by the 'description' method.
 */
+(NSString *)viewHierarchyDescription;

@end
