//
//  IndexViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "IndexViewController.h"
#import "SWStatusViewController.h"

@interface IndexViewController ()<GADBannerViewDelegate>

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation IndexViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorWhite;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@"制作状态",@"制作状态详情",@"制作消息",@"制作浏览页"];
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50 - self.qmui_navigationBarMaxYInViewCoordinator, self.view.frame.size.width, 50)];
    //广告单元的ID
    self.bannerView.adUnitID = @"ca-app-pub-6037095993957840/9771733149";
    self.bannerView.rootViewController = self;
    self.bannerView.backgroundColor = UIColorRandom;
    GADRequest *request = [GADRequest request];
    //如果是开发阶段，需要填写测试手机的UUID
    request.testDevices = @[@"081bbfd61c06743f7c07d230dc3199b0"];
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:request];
    [self.tableView addSubview:self.bannerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.textLabel.text = self.dataSource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWStatusViewController *statusController = [[SWStatusViewController alloc] init];
    [self.navigationController pushViewController:statusController animated:YES];
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing {
    return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing {
    return YES;
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"adView:didSuccess");
//    [UIView beginAnimations:@"BannerSlide" context:nil];
//    bannerView.frame = CGRectMake(0.0,
//                                  self.view.frame.size.height -
//                                  bannerView.frame.size.height,
//                                  bannerView.frame.size.width,
//                                  bannerView.frame.size.height);
//    [UIView commitAnimations];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

@end
