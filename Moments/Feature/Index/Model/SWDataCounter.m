//
//  SWDataCounter.m
//  Moments
//
//  Created by 宋国华 on 2018/10/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWDataCounter.h"

@implementation SWDataCounter

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSInteger)incrementaID {
    RLMResults<SWDataCounter *> *allObjcs = [[SWDataCounter allObjects] sortedResultsUsingKeyPath:@"id" ascending:YES];
    SWDataCounter *lastObjc = [allObjcs lastObject];
    return (lastObjc.id + 1);
}

+ (void)record {
    NSString *today = [[NSDate date] formatYMDWith:@"."];
//    NSString *whereStr = [NSString stringWithFormat:@"dateStr = '%@'",today];
//    RLMResults *todayRecords = [SWDataCounter objectsWhere:whereStr];
//    SWDataCounter *dataCounter = [todayRecords lastObject];
    
    NSDictionary *trafficMonitorings = [HTTraffic trafficMonitorings];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];

//    if (!dataCounter) {
        SWDataCounter *newDataCounter = [[SWDataCounter alloc] init];
        newDataCounter.id = [SWDataCounter incrementaID];
        newDataCounter.date = [NSDate date];
        newDataCounter.dateStr = [newDataCounter.date formatYMDWith:@"."];
        newDataCounter.wifiSent = [trafficMonitorings[DataCounterKeyWiFiSent] longLongValue];
        newDataCounter.wifiReceived = [trafficMonitorings[DataCounterKeyWiFiReceived] longLongValue];
        newDataCounter.wifiTotal = [trafficMonitorings[DataCounterKeyWiFiTotal] longLongValue];
        newDataCounter.wwanSent = [trafficMonitorings[DataCounterKeyWWANSent] longLongValue];
        newDataCounter.wwanReceived = [trafficMonitorings[DataCounterKeyWWANReceived] longLongValue];
        newDataCounter.wwanTotal = [trafficMonitorings[DataCounterKeyWWANTotal] longLongValue];
        [realm addObject:newDataCounter];
//    } else {
//        dataCounter.date = [NSDate date];
//        dataCounter.wifiSent = [trafficMonitorings[DataCounterKeyWiFiSent] longLongValue];
//        dataCounter.wifiReceived = [trafficMonitorings[DataCounterKeyWiFiReceived] longLongValue];
//        dataCounter.wifiTotal = [trafficMonitorings[DataCounterKeyWiFiTotal] longLongValue];
//        dataCounter.wwanSent = [trafficMonitorings[DataCounterKeyWWANSent] longLongValue];
//        dataCounter.wwanReceived = [trafficMonitorings[DataCounterKeyWWANReceived] longLongValue];
//        dataCounter.wwanTotal = [trafficMonitorings[DataCounterKeyWWANTotal] longLongValue];
//    }
    [realm commitWriteTransaction];
}

@end
