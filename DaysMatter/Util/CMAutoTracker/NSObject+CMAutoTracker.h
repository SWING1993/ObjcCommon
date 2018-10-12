//
//  NSObject+CMAutoTracker.h
//  美平米
//
//  Created by 宋国华 on 2018/7/30.
//  Copyright © 2018年 com.imicrothink. All rights reserved.
//

#import <Foundation/Foundation.h>

//给对象动态添加属性
@interface NSObject (CMAutoTracker)

@property (nonatomic ,strong) NSDictionary *cmInfoDictionary;

- (void)configInfoData:(id)obj;

@end
