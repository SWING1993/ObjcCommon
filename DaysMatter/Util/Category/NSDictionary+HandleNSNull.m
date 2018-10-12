//
//  NSDictionary+HandleNSNull.m
//  MpmMerchant
//
//  Created by Done.L on 2017/10/13.
//  Copyright © 2017年 hz7cm. All rights reserved.
//

#import "NSDictionary+HandleNSNull.h"

@implementation NSDictionary (HandleNSNull)

#pragma mark - Private

// 将NSDictionary中的Null类型的项目转化成@""
+ (NSDictionary *)nullDic:(NSDictionary *)myDic {
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

// 将NSDictionary中的Null类型的项目转化成@""
+ (NSArray *)nullArr:(NSArray *)myArr {
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++) {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

// 将NSString类型的原路返回
+ (NSString *)stringToString:(NSString *)string {
    return string;
}

//将Null类型的项目转化成@""
+ (NSString *)nullToString {
    return @"";
}

#pragma mark - Public

+ (id)changeType:(id)myObj {
    if ([myObj isKindOfClass:[NSDictionary class]]) {
        return [self nullDic:myObj];
    } else if([myObj isKindOfClass:[NSArray class]]) {
        return [self nullArr:myObj];
    } else if([myObj isKindOfClass:[NSString class]]) {
        return [self stringToString:myObj];
    } else if([myObj isKindOfClass:[NSNull class]]) {
        return [self nullToString];
    } else {
        return myObj;
    }
}

- (BOOL)boolForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        NSNumber *num = [self objectForKey:key];
        return [num isKindOfClass:[NSNumber class]]?num.boolValue:NO;
    }
    
    return NO;
}

@end
