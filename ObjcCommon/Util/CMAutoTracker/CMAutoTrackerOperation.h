//
//  CMAutoTrackerOperation.h
//  美平米
//
//  Created by 宋国华 on 2018/7/30.
//  Copyright © 2018年 com.imicrothink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+CMAutoTracker.h"

@interface CMAutoTrackerOperation : NSObject

+ (CMAutoTrackerOperation *)sharedInstance;


/** 自定义事件,数量统计.
 @param  eventId 网站上注册的事件Id.
 @return void.
 */
- (void)sendEvent:(NSString *)eventId;

/** 自定义事件,数量统计. 
 @param  eventId 网站上注册的事件Id.
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @return void.
 */
- (void)sendEvent:(NSString *)eventId label:(NSString *)label;

/**
 发送日志
 
 @param eventId 日志id
 @param attributes 日志内容
 */
- (void)sendEvent:(NSString *)eventId attributes:(NSDictionary *)attributes;

/** 自动页面时长统计, 开始记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
- (void)beginLogPageView:(NSString *)pageName;

/** 自动页面时长统计, 结束记录某个页面展示时长.
 使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
- (void)endLogPageView:(NSString *)pageName;

@end
