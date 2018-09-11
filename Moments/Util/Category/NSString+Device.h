//
//  NSString+Device.h
//  MpmMerchant
//
//  Created by 楼栋烨 on 2017/11/15.
//  Copyright © 2017年 hz7cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Device)

//获取iPhone型号
+ (NSString *)deviceVersion;

//获取app的版本号
+ (NSString *)getAppVersion;

// 获取UUID
+ (NSString *)getUUID;

// 获取手机系统版本
+ (NSString *)systemVersion;
@end
