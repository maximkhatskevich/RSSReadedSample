//
//  NSDictionary+RSS.h
//  RSSReaderSamle
//
//  Created by Maxim Khatskevich on 4/2/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#define cTitleKeyName		@"title"
#define cDescriptionKeyName	@"description"
#define cLinkKeyName		@"link"
#define cPubDateKeyName		@"pubDate"

@interface NSDictionary (RSS)

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *link;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, readonly) NSString *pubDate;

@end
