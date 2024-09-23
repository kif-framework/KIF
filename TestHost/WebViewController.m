//
//  WebViewController.m
//  KIF
//
//  Created by Joe Masilotti on 11/19/14.
//
//
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
