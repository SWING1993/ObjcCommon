//
//  SWViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface SWViewController ()

@property (nonatomic, strong) GADBannerView *bView;

@end

@implementation SWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _bView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    //这个就是你添加的广告单元的ID
//    _bView.adUnitID = @"ca-app-pub-6037095993957840/9771733149";
//    _bView.rootViewController = self;
//    GADRequest *request = [GADRequest request];
//    //如果是开发阶段，需要填写测试手机的UUID，不填写可能会误会你自己刷展示量
//    request.testDevices = @[@"测试设备的UUID"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
