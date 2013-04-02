//
//  NSArray+Helpers.m
//  iConvy
//
//  Created by Maxim Khatskevich on 2/6/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (BOOL)isValidIndex:(NSUInteger)indexForTest
{
    return (indexForTest < self.count);
}

- (id)objectAtIndexSafe:(NSUInteger)index
{
    return ([self isValidIndex:index] ? self[index] : nil);
}

@end
