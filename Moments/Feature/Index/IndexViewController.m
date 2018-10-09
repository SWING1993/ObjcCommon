//
//  IndexViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "IndexViewController.h"
#import "SWStatusViewController.h"
#import "SWMessageViewController.h"
#import "SWAuthor.h"
#import "SWFeedbackViewController.h"
#import "SWInstructionsViewController.h"

@interface IndexViewController ()<GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) QMUIGridView *gridView;

@end

@implementation IndexViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorForBackground;
    [self setTitle:@"发现"];
    
    self.gridView = [[QMUIGridView alloc] init];
    self.gridView.columnCount = 3;
    self.gridView.rowHeight = kScreenW/3;
    self.gridView.separatorWidth = PixelOne;
    [self.view addSubview:self.gridView];
    
    NSArray *dataSource = @[@"制作朋友圈",@"制作消息",@"使用说明",@"反馈"];
    NSArray *iconName = @[@"朋友圈",@"消息",@"说明",@"反馈"];

    for (NSInteger i = 0; i < dataSource.count; i++) {
        QMUIButton *btn = [[QMUIButton alloc] init];
        btn.tag = i;
        btn.titleLabel.font = UIFontMake(14);
        btn.imagePosition = QMUIButtonImagePositionTop;// 将图片位置改为在文字上方
        btn.spacingBetweenImageAndTitle = 10;
        [btn setBackgroundColor:UIColorWhite];
        UIImage *icon = UIImageMake(iconName[i]);
        [btn setImage:icon forState:UIControlStateNormal];
        [btn setTitle:dataSource[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorMakeX(61) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.gridView addSubview:btn];
    }
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
        [self addAuthor];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:request];
}

- (void)clickMenuAction:(QMUIButton *)sender {
    switch (sender.tag) {
            case 0: {
                SWStatusViewController *controller = [[SWStatusViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
            
            case 1: {
                SWMessageViewController *controller = [[SWMessageViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
            case 2: {
                // 使用说明
                SWInstructionsViewController *controller = [[SWInstructionsViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
//            case 3: {
//                // 分享
//                SWMessageViewController *controller = [[SWMessageViewController alloc] init];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//            break;
            
            case 3:{
                SWFeedbackViewController *controller = [[SWFeedbackViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        default:
            break;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.gridView.frame = CGRectMake(0, self.qmui_navigationBarMaxYInViewCoordinator, CGRectGetWidth(self.view.bounds), QMUIViewSelfSizingHeight);
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

- (void)addAuthor {
    RLMRealm *authorRealm = [RLMRealm defaultRealm];
    RLMResults *allAuthor = [SWAuthor allObjects];
    if (allAuthor.count == 0) {
        NSArray *nicknames = @[@"煎饼侠",@"萌萌",@"皮卡丘",@"凹凸曼",@"拉克丝",@"小鑫鑫",@"琪琪",@"喵",@"Laurinda",@"阿狸",@"Fiona",@"Lee",@"雅彤",@"璐璐",@"SuperMan",@"可儿",@"雅静",@"Jennifer",@"路飞",@"达孟",@"蛋儿",@"茉莉",@"小薇",@"小翔",@"Adele",@"李菲菲",@"haha",@"ZZ",@"Lacey",@"星爷",@"Selena",@"周归璨",@"Wendy",@"Queenie",@"Lana",@"阿颖"];
        [authorRealm beginWriteTransaction];
        for (int i = 0; i < nicknames.count; i ++) {
            SWAuthor *author = [[SWAuthor alloc] init];
            author.nickname = nicknames[i];
            NSString *imageName = [NSString stringWithFormat:@"avatar%d.jpg",i];
            author.avatar = [SWStatus saveImage:[UIImage imageNamed:imageName]];
            [authorRealm addObject:author];
        }
        [authorRealm commitWriteTransaction];
    }
}


@end
