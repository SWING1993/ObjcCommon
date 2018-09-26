//
//  SWViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"

@interface SWViewController ()

@end

@implementation SWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/// @warning 需在项目的 Info.plist 文件内设置字段 “View controller-based status bar appearance” 的值为 NO 才能生效，如果不设置，或者值为 YES，则请使用系统提供的 - preferredStatusBarStyle 方法
- (BOOL)shouldSetStatusBarStyleLight {
    return YES;
}

/// 设置titleView的tintColor
- (nullable UIColor *)titleViewTintColor {
    return QMUICMI.navBarTintColor;
}

/// 设置导航栏的背景图，默认为NavBarBackgroundImage
- (nullable UIImage *)navigationBarBackgroundImage {
    return QMUICMI.navBarBackgroundImage;
}

/// 设置当前导航栏的UIBarButtonItem的tintColor，默认为NavBarTintColor
- (nullable UIColor *)navigationBarTintColor {
    return QMUICMI.navBarTitleColor;
}

@end
