//
//  DraggingViewController.m
//  KIF
//
//  Created by Michael Lupo on 6/12/15.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface DraggingViewController: UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *monkeyImage;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
@end

@implementation DraggingViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {

	CGPoint translation = [recognizer translationInView:self.view];
	recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
										 recognizer.view.center.y + translation.y);
	[recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

	if(recognizer.state == UIGestureRecognizerStateEnded)
	{
		SEND_UITEST_NOTIFICATION(@"draggingEnded", 0);
	}

}
@end