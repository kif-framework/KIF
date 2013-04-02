//
//  UIEvent+KIFAssociations.h
//  KIF
//
//  Created by Nate Chandler on 4/2/13.
//
//

#import <UIKit/UIKit.h>

@interface UIEvent (KIFAssociations)
- (void)kif_setAssociatedTouches:(NSSet *)touches;
- (NSSet *)kif_associatedTouches;
- (void)kif_setAssociatedTouch:(UITouch *)touch;
- (UITouch *)kif_associatedTouch;
@end
