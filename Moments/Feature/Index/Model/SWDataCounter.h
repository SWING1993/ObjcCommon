//
//  SWDataCounter.h
//  Moments
//
//  Created by 宋国华 on 2018/10/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Realm/Realm.h>

@interface SWDataCounter : RLMObject
// id
@property NSInteger id;
// wifi
@property long long wifiSent;
@property long long wifiReceived;
@property long long wifiTotal;
// wwan
@property long long wwanSent;
@property long long wwanReceived;
@property long long wwanTotal;
// yyyy-MM-dd
@property NSString *dateStr;
@property NSDate *date;

+ (NSInteger)incrementaID;

+ (void)record;

@end
