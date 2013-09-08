//
//  KIFTypist.h
//  KIF
//
//  Created by Pete Hodgson on 8/12/12.
//
//

@interface KIFTypist : NSObject
+ (void) cancelAnyInitialKeyboardShift;
+ (BOOL)enterCharacter:(NSString *)characterString;
@end
