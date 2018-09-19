//
//  NSString+Device.m
//  MpmMerchant
//
//  Created by 楼栋烨 on 2017/11/15.
//  Copyright © 2017年 hz7cm. All rights reserved.
//

#import "NSString+Device.h"
#import "sys/utsname.h"

@implementation NSString (Device)

// 设备版本
+ (NSString *)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}

//获取app的版本号
+ (NSString*)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// 获取UUID
+ (NSString *)getUUID {
    return  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


 //获取手机系统版本
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}
@end
