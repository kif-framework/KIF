//
//  SystemAlertViewController.m
//  KIF
//
//  Created by Joe Masilotti on 12/1/14.
//
//

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SystemAlertViewController : UIViewController
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation SystemAlertViewController

// Every button on this screen is a bold-system-font push that fires one access request.
- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:0.42467421293258667 green:0.42466151714324951 blue:0.42466866970062256 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];

    [view addSubview:[self buttonWithFrame:CGRectMake(85, 20, 150, 44)
                                     title:@"Location Services"
                                    action:@selector(requestLocationServicesAccess)]];

    [view addSubview:[self buttonWithFrame:CGRectMake(123, 71, 74, 44)
                                     title:@"Photos"
                                    action:@selector(requestPhotosAccess)]];

    [view addSubview:[self buttonWithFrame:CGRectMake(104, 122, 113, 44)
                                     title:@"Notifications"
                                    action:@selector(requestNotificationScheduling)]];

    UIButton *bothButton = [self buttonWithFrame:CGRectMake(24, 182, 273, 44)
                                           title:@"Location Services and Notifications"
                                          action:@selector(requestLocationServicesAndNotificicationsSchedulingAccesses)];
    [bothButton setTitleColor:[UIColor colorWithRed:0.14959937334060669 green:0.23496778309345245 blue:0.44619548320770264 alpha:1] forState:UIControlStateNormal];
    [bothButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [view addSubview:bothButton];

    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
}

- (void)requestLocationServicesAccess {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)requestPhotosAccess {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)requestNotificationScheduling {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)requestLocationServicesAndNotificicationsSchedulingAccesses {
	[self requestLocationServicesAccess];
	[self requestNotificationScheduling];
}

@end
