//
//  SCWebViewController.m
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/30/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#import "SCWebViewController.h"
#import "MBProgressHUD.h"

@interface SCWebViewController ()

@end

@implementation SCWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* Loading the URL passed form the previous view */
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [super viewDidUnload];
}

#pragma mark - UIWebViewDelegate
/* Handling the Loading View based on the status of the WebView */
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
@end
