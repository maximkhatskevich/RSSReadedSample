//
//  NSArray+Helpers.h
//  iConvy
//
//  Created by Maxim Khatskevich on 2/6/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Helpers)

- (BOOL)isValidIndex:(NSUInteger)indexForTest;
- (id)objectAtIndexSafe:(NSUInteger)index;

@end
