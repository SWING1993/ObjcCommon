//
//  HTTraffic.h
//  Moments
//
//  Created by 宋国华 on 2018/10/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTraffic : NSObject

+ (NSDictionary *)trafficMonitorings;

- (NSString *)bytesToAvaiUnit:(int)bytes;

@end

