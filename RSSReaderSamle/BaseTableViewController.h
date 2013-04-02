//
//  BaseTableViewController.h
//  RSSReaderSamle
//
//  Created by Maxim Khatskevich on 4/2/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *activityIndicatorBackground;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString *shortTitle;
@property (copy, nonatomic) NSString *targetUrlStr;

- (IBAction)refreshContent:(id)sender;

@end
