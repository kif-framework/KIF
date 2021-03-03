//
//  ViewController.m
//  KIFSwiftPMConsumer
//
//  Created by Derek Ostrander on 3/1/21.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testLabel.accessibilityLabel = @"Test Label";
}


@end
