//
//  NSDictionary+HandleNSNull.h
//  MpmMerchant
//
//  Created by Done.L on 2017/10/13.
//  Copyright © 2017年 hz7cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HandleNSNull)

+ (NSDictionary *_Nullable)nullDic:(NSDictionary *_Nullable)myDic;
+ (NSArray *_Nullable)nullArr:(NSArray *_Nullable)myArr;
+ (NSString *_Nullable)stringToString:(NSString *_Nullable)string;
+ (NSString *_Nullable)nullToString;
+ (id _Nullable )changeType:(id _Nullable )myObj;


/**
 获得布尔值
 
 @param key 键
 @return 值
 */
- (BOOL)boolForKey:(nonnull NSString *)key;

@end
