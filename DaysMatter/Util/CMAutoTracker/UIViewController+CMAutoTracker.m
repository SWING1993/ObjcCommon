//
//  UIViewController+CMAutoTracker.m
//  美平米
//
//  Created by 宋国华 on 2018/7/30.
//  Copyright © 2018年 com.imicrothink. All rights reserved.
//

#import "UIViewController+CMAutoTracker.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "CMAutoTrackerOperation.h"
#import "NSObject+CMAutoTracker.h"

@implementation UIViewController (CMAutoTracker)

+ (void)startTracker {
    // 交换方法
    Method viewDidAppear = class_getInstanceMethod(self, @selector(viewDidAppear:));
    Method cmViewDidAppear= class_getInstanceMethod(self, @selector(cm_viewDidAppear:));
    method_exchangeImplementations(viewDidAppear, cmViewDidAppear);
    
    Method viewDidDisappear = class_getInstanceMethod(self, @selector(viewDidDisappear:));
    Method cmViewDidDisappear= class_getInstanceMethod(self, @selector(cm_viewDidDisappear:));
    method_exchangeImplementations(viewDidDisappear, cmViewDidDisappear);
}

- (void)cm_viewDidAppear:(BOOL)animated {
    NSString *pageName = [NSString stringWithString:NSStringFromClass([self class])];
    [[CMAutoTrackerOperation sharedInstance] beginLogPageView:pageName];
    [self cm_viewDidAppear:animated];
}

- (void)cm_viewDidDisappear:(BOOL)animated {
    NSString *pageName = [NSString stringWithString:NSStringFromClass([self class])];
    [[CMAutoTrackerOperation sharedInstance] endLogPageView:pageName];
    [self cm_viewDidDisappear:animated];
}

@end
