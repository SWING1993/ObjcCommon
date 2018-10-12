//
//  HTTraffic.h
//  Moments
//
//  Created by 宋国华 on 2018/10/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DataCounterKeyWWANSent = @"WWANSent";
static NSString *const DataCounterKeyWWANReceived = @"WWANReceived";
static NSString *const DataCounterKeyWWANTotal = @"WWANTotal";
static NSString *const DataCounterKeyWiFiSent = @"WiFiSent";
static NSString *const DataCounterKeyWiFiReceived = @"WiFiReceived";
static NSString *const DataCounterKeyWiFiTotal = @"WiFiTotal";

@interface HTTraffic : NSObject

+ (NSDictionary *)trafficMonitorings;

+ (NSString *)bytesToAvaiUnit:(long long)bytes;

@end

