//
//  SCWebViewController.h
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/30/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCWebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSURL *url;

@end
