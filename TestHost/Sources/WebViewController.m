//
//  WebViewController.m
//  KIF
//
//  Created by Joe Masilotti on 11/19/14.
//
//

@interface WebViewController : UIViewController
// The WebViewTests exercise KIF's UIWebView support. KIF can't see WKWebView content, because its
// accessibility tree lives in WebKit's out-of-process WebContent process.
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation WebViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 804)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(9, 5, 391, 500)];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.webView];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
