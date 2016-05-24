//
//  KIFProxyDelegate.h
//  KIF
//
//

#import <Foundation/Foundation.h>

/*!
 * @abstract @c KIFProxyDelegate serves as a proxy delegate between the @c original and @c replacement
 * @discussion This class lets the @c replacement delegate intercept and act on all messages sent to this object, before @c original gets them. 
 
   @c KIFProxyDelegate @b does @b not retain the delegates, so ensure the object representing the delegate is retain long enough for your use case.
 */
@interface KIFProxyDelegate : NSProxy

@property (nonatomic, weak, readonly) id original;

- (instancetype)initWithOriginalDelegate:(id)original
                     replacementDelegate:(id)replacement;

@end
