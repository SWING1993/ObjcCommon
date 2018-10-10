//
//  IndexViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()<GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation IndexViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorForBackground;
    [self setTitle:@"发现"];
    NSLog(@"zzz-----%zi",[[NSUserDefaults standardUserDefaults] integerForKey:@"application"]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, self.view.qmui_height - 50 - self.qmui_navigationBarMaxYInViewCoordinator, self.view.qmui_width, 50)];
    self.bannerView.adUnitID = @"ca-app-pub-6037095993957840/9771733149";
    self.bannerView.rootViewController = self;
    [self.view addSubview:self.bannerView];

    @weakify(self)
    dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        @strongify(self)
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing {
    return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing {
    return YES;
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"adView:didSuccess");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

@end
