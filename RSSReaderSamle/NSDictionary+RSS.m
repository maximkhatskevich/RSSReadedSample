//
//  NSDictionary+RSS.m
//  RSSReaderSamle
//
//  Created by Maxim Khatskevich on 4/2/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSDictionary+RSS.h"

@implementation NSDictionary (RSS)

- (NSString *)title
{
    NSString *result = self[cTitleKeyName];
    
    //===
    
    if (!result || [result isEqualToString:@""])
    {
        result = @"(No title)";
    }
    
    //===
    
    return result;
}

- (NSString *)link
{
    return self[cLinkKeyName];
}

- (NSString *)description
{
    return self[cDescriptionKeyName];
}

- (NSString *)pubDate
{
    return self[cPubDateKeyName];
}

@end
