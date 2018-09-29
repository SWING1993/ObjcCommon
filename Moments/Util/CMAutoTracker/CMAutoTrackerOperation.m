//
//  CMAutoTrackerOperation.m
//  美平米
//
//  Created by 宋国华 on 2018/7/30.
//  Copyright © 2018年 com.imicrothink. All rights reserved.
//

#import "CMAutoTrackerOperation.h"

#import "NSObject+CMAutoTracker.h"
#import <UMAnalytics/MobClick.h>
#import "UIViewController+CMAutoTracker.h"

@implementation CMAutoTrackerOperation

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        [UIViewController startTracker];
    });
    return _sharedInstance;
}

- (void)sendEvent:(NSString *)eventId {
    if ([NSString isBlankString:eventId]) {
        return;
    }
    [MobClick event:eventId];
}

- (void)sendEvent:(NSString *)eventId label:(NSString *)label {
    if ([NSString isBlankString:eventId]) {
        return;
    }
    [MobClick event:eventId label:label];
}

- (void)sendEvent:(NSString *)eventId attributes:(NSDictionary *)attributes {
    if ([NSString isBlankString:eventId]) {
        return;
    }
    [MobClick event:eventId attributes:attributes];
}

- (void)beginLogPageView:(NSString *)pageName {
    [MobClick beginLogPageView:pageName];
}

- (void)endLogPageView:(NSString *)pageName {
    [MobClick endLogPageView:pageName];
}

@end
