//
//  IndexViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "IndexViewController.h"
#import "SWColorViewController.h"


@interface IndexViewController ()<GADBannerViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation IndexViewController

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorForBackground;
    [self setTitle:@"发现"];
}

- (void)initTableView {
    [super initTableView];
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"zzz-----%zi",[[NSUserDefaults standardUserDefaults] integerForKey:@"application"]);

    [SWDataCounter record];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    RLMResults<SWDataCounter *> *allObjcs = [SWDataCounter allObjects];
    self.dataSource = [NSMutableArray arrayWithCapacity:allObjcs.count];
    for (int i = 0; i < allObjcs.count; i ++) {
        SWDataCounter *dataCounter = [allObjcs objectAtIndex:i];
        [self.dataSource addObject:dataCounter];
    }
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = UIColorMakeX(33);
        cell.detailTextLabel.textColor = UIColorGray;
    }
    SWDataCounter *dataCounter = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [dataCounter.date formatYMDHM];
    
    NSString*wifi = [NSString stringWithFormat:@"Wifi 总共:%@ 发送:%@ 接收:%@",[HTTraffic bytesToAvaiUnit:dataCounter.wifiTotal],[HTTraffic bytesToAvaiUnit:dataCounter.wifiSent],[HTTraffic bytesToAvaiUnit:dataCounter.wifiReceived]];
    NSString*wwan= [NSString stringWithFormat:@"\n流量 总共:%@ 发送:%@ 接收:%@",[HTTraffic bytesToAvaiUnit:dataCounter.wwanTotal],[HTTraffic bytesToAvaiUnit:dataCounter.wwanSent],[HTTraffic bytesToAvaiUnit:dataCounter.wwanReceived]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",wifi,wwan];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWColorViewController *controller = [[SWColorViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
