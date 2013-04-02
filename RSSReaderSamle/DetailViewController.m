//
//  DetailViewController.m
//  RSSReaderSamle
//
//  Created by Maxim Khatskevich on 4/2/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UIWebViewDelegate>
{
    BOOL _firstTime;
}

@end

@implementation DetailViewController

#pragma mark - Property accessors

- (UIWebView *)webView
{
    UIWebView *result = nil;
    
    //===
    
    if (self.view &&
        [self.view isKindOfClass:[UIWebView class]])
    {
        result = (UIWebView *)self.view;
    }
    
    //===
    
    return result;
}

- (IBAction)openInBrowser:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.externalLink]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL result = _firstTime;
    
    //===
    
    if (_firstTime)
    {
        _firstTime = NO;
    }
    else
    {
        [[UIApplication sharedApplication] openURL:request.URL];
    }
    
    //===
    
    return result;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Overrided methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //===
    
    self.webView.delegate = self;
    _firstTime = YES;
}

@end
