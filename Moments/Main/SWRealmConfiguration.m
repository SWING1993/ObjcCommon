//
//  SWRealmConfiguration.m
//  Moments
//
//  Created by 宋国华 on 2018/10/9.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWRealmConfiguration.h"

@implementation SWRealmConfiguration

+ (RLMRealm *)authorRealm {
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * pathName = [path stringByAppendingString:@"/author.realm"];
    return [RLMRealm realmWithURL:[NSURL URLWithString:pathName]];
}

@end
