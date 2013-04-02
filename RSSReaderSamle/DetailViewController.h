//
//  DetailViewController.h
//  RSSReaderSamle
//
//  Created by Maxim Khatskevich on 4/2/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, copy) NSString *externalLink;

- (IBAction)openInBrowser:(id)sender;

@end
