//
//  NSObject+CMAutoTracker.m
//  美平米
//
//  Created by 宋国华 on 2018/7/30.
//  Copyright © 2018年 com.imicrothink. All rights reserved.
//

#import "NSObject+CMAutoTracker.h"
#import <objc/runtime.h>

static void * cmInfoDictionaryPropertyKey = &cmInfoDictionaryPropertyKey;

@implementation NSObject (DDAutoTracker)


- (NSDictionary *)cmInfoDictionary {
    return objc_getAssociatedObject(self, cmInfoDictionaryPropertyKey);

}

- (void)setCmInfoDictionary:(NSDictionary *)cmInfoDictionary {
    if (cmInfoDictionary) {
        objc_setAssociatedObject(self, cmInfoDictionaryPropertyKey, cmInfoDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)configInfoData:(id)obj {
    if (nil == obj) {
        return;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        self.cmInfoDictionary = obj;
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([obj class], &count);
        
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            if (key.length > 0 &&
                [obj valueForKey:key]) {
                [dict setObject:[obj valueForKey:key] forKey:key];
            }
        }
        
        free(properties);
        
        if (dict) {
            self.cmInfoDictionary = dict;
        }
    }
}

@end
