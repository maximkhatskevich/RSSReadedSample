//
//  BaseTableViewController.m
//  RSSReaderSamle
//
//  Created by Maxim Khatskevich on 4/2/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NSDictionary+RSS.h"
#import "BaseTableViewCell.h"
#import "DetailViewController.h"
#import "NSArray+Helpers.h"
#import "UIView+Helpers.h"

#define defaultQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define mainQueue dispatch_get_main_queue()

@interface BaseTableViewController () <NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL _firstTime;
}

@property (nonatomic, strong) NSXMLParser *parser;

@property BOOL feedLevel;
@property (nonatomic, strong) NSMutableDictionary *feedInfo;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *currentItem;
@property (nonatomic, strong) NSString *currentPropertyName;
@property (nonatomic, strong) NSString *currentCharacterStr;

@end

@implementation BaseTableViewController

#pragma mark - IBActions

- (IBAction)refreshContent:(id)sender
{
    [self showRefreshStarted];
    
    dispatch_async(defaultQueue, ^(void) {
        
        NSURL *url = [NSURL URLWithString:self.targetUrlStr];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        [self.parser setDelegate:self];
        
        self.items = [NSMutableArray array];
        self.currentItem = nil;
        self.currentPropertyName = nil;
        self.currentCharacterStr = @"";
        
        self.feedLevel = YES;
        self.feedInfo = [NSMutableDictionary dictionary];
        [self.parser parse];
    });
}

#pragma mark - Helpers

- (void)showRefreshStarted
{
    [self.activityIndicatorBackground show];
    [self.activityIndicator show];
    [self.activityIndicator startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)showRefreshFinished
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.activityIndicator stopAnimating];
    [self.activityIndicator hide];
    [self.activityIndicatorBackground hide];
}

#pragma mark - Overrided methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //===
    
    _firstTime = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_firstTime)
    {
        [self refreshContent:nil];
        _firstTime = NO;
    }
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToDetailView"])
    {
        NSInteger selectedItemIndex = self.tableView.indexPathForSelectedRow.row;
        NSDictionary *selectedItem = [self.items objectAtIndexSafe:selectedItemIndex];
        
        DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
        
        detailViewController.title = selectedItem.title;
        detailViewController.externalLink = selectedItem.link;
        [detailViewController.webView loadHTMLString:selectedItem.description baseURL:nil];
    }
}

- (void)viewWillUnload
{
    
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
//    NSLog(@"%@", @"Parsing started");
    self.title = @"Loading...";
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//    NSLog(@"%@", self.feedInfo);
    
    dispatch_async(mainQueue, ^(void) {
        
        self.title = self.feedInfo.title;
        self.navigationController.tabBarItem.title = self.shortTitle;
        
        [self showRefreshFinished];
        
        [self.tableView reloadData];
    });
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"didStartElement => %@", elementName);
	
    if([elementName isEqualToString:@"item"]) {
        self.feedLevel = NO;
		self.currentItem = [NSMutableDictionary dictionary];
	}
	else {
		self.currentPropertyName = [[NSString alloc] initWithString:elementName];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"currentCharacterStr == %@", self.currentCharacterStr);
//    NSLog(@"didEndElement <= %@", elementName);
//    
//    NSLog(@"------------------------");
	
    // feed properties:
    if (self.feedLevel)
    {
        if (self.currentCharacterStr &&
            self.currentPropertyName &&
            [elementName isEqualToString:self.currentPropertyName])
        {
            [self.feedInfo setObject:self.currentCharacterStr forKey:self.currentPropertyName];
            self.currentPropertyName = nil;
            self.currentCharacterStr = @"";
        }
    }
    
    // end of item:
    else if(self.currentItem &&
            [elementName isEqualToString:@"item"])
    {
		[self.items addObject:self.currentItem];
		self.currentItem = nil;
        self.currentPropertyName = nil;
        self.currentCharacterStr = @"";
	}
    
    // end of item property:
    else if (self.currentCharacterStr &&
             self.currentPropertyName &&
             [elementName isEqualToString:self.currentPropertyName])
    {
        [self.currentItem setObject:self.currentCharacterStr forKey:self.currentPropertyName];
        self.currentPropertyName = nil;
        self.currentCharacterStr = @"";
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"foundCharacters => %@", string);
	
    if ([self.currentPropertyName isEqualToString:cPubDateKeyName])
    {
        static NSDateFormatter *inFormatter = nil;
        static NSDateFormatter *outFormatter = nil;
        static NSDate *bufDate = nil;
        
        if (!inFormatter)
        {
            inFormatter = [NSDateFormatter new];
            [inFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
            
            outFormatter = [NSDateFormatter new];
            [outFormatter setDateFormat:@"dd MMM HH:mm"]; //for example...
        }
        
        //===
        
        bufDate = [inFormatter dateFromString:string];
        string = [outFormatter stringFromDate:bufDate];
    }
    
    //===
    
    if (string)
    {
        self.currentCharacterStr = [self.currentCharacterStr stringByAppendingString:string];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *item = self.items[indexPath.row];
    
    // Configure the cell...
    cell.titleLabel.text = item.title;
    cell.dateLabel.text = item.pubDate;
    
    //===
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
