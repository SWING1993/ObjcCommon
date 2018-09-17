//
//  SWAuthor.m
//  Moments
//
//  Created by 宋国华 on 2018/9/17.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWAuthor.h"

@implementation SWAuthor

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSInteger)incrementaID {
    RLMResults<SWAuthor *> *allStatus = [[SWAuthor allObjects] sortedResultsUsingKeyPath:@"id" ascending:YES];
    SWAuthor *lastObjc = [allStatus lastObject];
    return (lastObjc.id + 1);
}

@end
