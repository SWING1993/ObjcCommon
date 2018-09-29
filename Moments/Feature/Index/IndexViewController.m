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

@interface IndexViewController ()<GADBannerViewDelegate>

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation IndexViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorWhite;
    [self setTitle:@"朋友圈制作"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@"朋友圈",@"状态详情",@"浏览页",@"消息"];
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, self.view.qmui_height - 50 - self.qmui_navigationBarMaxYInViewCoordinator, self.view.qmui_width, 50)];
    self.bannerView.adUnitID = @"ca-app-pub-6037095993957840/9771733149";
    self.bannerView.rootViewController = self;
    [self.tableView addSubview:self.bannerView];
    
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
    switch (indexPath.section) {
        case 0: {
            SWStatusViewController *controller = [[SWStatusViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        case 1: {
           
        }
            break;
            
        case 2: {
           
        }
            break;
            
        case 3: {
            SWMessageViewController *controller = [[SWMessageViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    
        default:
            break;
    }
   
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
    //串行队列
    dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        RLMResults *allAuthor = [SWAuthor allObjects];
        if (allAuthor.count == 0) {
            NSArray *nicknames = @[@"煎饼侠",@"萌萌",@"皮卡丘",@"凹凸曼",@"拉克丝",@"小鑫鑫",@"琪琪",@"喵",@"Laurinda",@"阿狸",@"Fiona",@"Lee",@"雅彤",@"璐璐",@"SuperMan",@"可儿",@"雅静",@"Jennifer",@"路飞",@"达孟",@"蛋儿",@"茉莉",@"小薇",@"小翔",@"Adele",@"李菲菲",@"haha",@"ZZ",@"Lacey",@"星爷",@"Selena",@"周归璨",@"Wendy",@"Queenie",@"Lana",@"阿颖"];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            for (int i = 0; i < nicknames.count; i ++) {
                SWAuthor *author = [[SWAuthor alloc] init];
                author.id = i;
                author.nickname = nicknames[i];
                NSString *imageName = [NSString stringWithFormat:@"avatar%d.jpg",i];
                author.avatar = [SWStatus saveImage:[UIImage imageNamed:imageName]];
                [realm addObject:author];
            }
            [realm commitWriteTransaction];
        }
    });
}


@end
