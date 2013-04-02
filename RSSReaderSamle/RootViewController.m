//
//  RootViewController.m
//  RSSReaderSamle
//
//  Created by Maxim Khatskevich on 4/2/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "RootViewController.h"
#import "BaseTableViewController.h"
#import "UIStoryboard+Helpers.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //===
    
    UITabBarItem *tabBarItem = nil;
    UINavigationController *navigationController = nil;
    BaseTableViewController *tableViewController = nil;
    NSMutableArray *tabRootViewControllers = [NSMutableArray array];
    
    //===
    
    // Vimeo:
    navigationController = [[UIStoryboard currentStoryboard]
                            instantiateViewControllerWithIdentifier:@"FeedNavigationController"];
    tableViewController = ((BaseTableViewController *)navigationController.topViewController);
    tableViewController.shortTitle = @"Vimeo";
    tableViewController.targetUrlStr = @"http://vimeo.com/gopro/videos/rss";
    
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Vimeo"
                                               image:[UIImage imageNamed:@"vimeo"]
                                                 tag:0];
    
    navigationController.tabBarItem = tabBarItem;
    [tabRootViewControllers addObject:navigationController];
    
    //===
    
    // Apple:
    navigationController = [[UIStoryboard currentStoryboard]
                            instantiateViewControllerWithIdentifier:@"FeedNavigationController"];
    tableViewController = (BaseTableViewController *)navigationController.topViewController;
    tableViewController.shortTitle = @"Apple";
    tableViewController.targetUrlStr = @"http://images.apple.com/main/rss/hotnews/hotnews.rss";
    
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Apple"
                                               image:[UIImage imageNamed:@"apple"]
                                                 tag:0];
    
    navigationController.tabBarItem = tabBarItem;
    [tabRootViewControllers addObject:navigationController];
    
    //===
    
    // Pinterest:
    navigationController = [[UIStoryboard currentStoryboard]
                            instantiateViewControllerWithIdentifier:@"FeedNavigationController"];
    tableViewController = (BaseTableViewController *)navigationController.topViewController;
    tableViewController.shortTitle = @"Pinterest";
    tableViewController.targetUrlStr = @"http://pinterest.com/modaoperandi/the-moda-life/rss";
    
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Pinterest"
                                               image:[UIImage imageNamed:@"pinterest"]
                                                 tag:0];
    
    navigationController.tabBarItem = tabBarItem;
    [tabRootViewControllers addObject:navigationController];
    
    //===
    
    // Google:
    navigationController = [[UIStoryboard currentStoryboard]
                            instantiateViewControllerWithIdentifier:@"FeedNavigationController"];
    tableViewController = (BaseTableViewController *)navigationController.topViewController;
    tableViewController.shortTitle = @"Google";
    tableViewController.targetUrlStr = @"http://news.google.com/news?pz=1&cf=all&ned=us&hl=en&topic=h&num=3&output=rss";
    
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Google"
                                               image:[UIImage imageNamed:@"google"]
                                                 tag:0];
    
    navigationController.tabBarItem = tabBarItem;    
    [tabRootViewControllers addObject:navigationController];
    
    //===
    
    [self setViewControllers:tabRootViewControllers];
    self.selectedIndex = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
