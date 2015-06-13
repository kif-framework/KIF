//
//  AppDelegate.h
//  KIF
//
//  Created by Michael Lupo on 6/13/15.
//
//

#ifndef KIF_AppDelegate_h
#define KIF_AppDelegate_h

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

+(instancetype) getAppDelegate;

- (void) sendNotification:(NSString *)nString delay:(NSTimeInterval)delay userInfo:(id)userInfo;

#define SEND_UITEST_NOTIFICATION(s,d)	do { [[AppDelegate getAppDelegate] sendNotification:(s) delay:(d) userInfo:nil]; } while (NO)
@end

#endif
