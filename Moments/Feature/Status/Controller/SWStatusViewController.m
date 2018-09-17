//
//  SWStatusViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusViewController.h"
#import "SWStatusPostViewController.h"
#import "SWStatusCellLayout.h"
#import "SWStatusCell.h"

@interface SWStatusViewController () <QMUITableViewDelegate, QMUITableViewDataSource>

@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) NSMutableArray <SWStatusCellLayout *>*dataSource;

@end

@implementation SWStatusViewController

- (void)initSubviews {
    [super initSubviews];
    [self setTitle:@"朋友圈"];
    self.tableView = [[QMUITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"Moment_Post") style:UIBarButtonItemStyleDone target:self action:@selector(postStatusAction)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

#pragma mark - Actions
- (void)postStatusAction {
    SWStatusPostViewController *postViewController = [[SWStatusPostViewController alloc] init];
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)reloadData {
    // 从默认 Realm 中，检索所有的状态
    RLMResults<SWStatus *> *allStatus = [SWStatus allObjects];
    self.dataSource = [NSMutableArray arrayWithCapacity:allStatus.count];
    for (NSInteger index = allStatus.count - 1; index > -1; index --) {
        SWStatus *status = [allStatus objectAtIndex:index];
        SWStatusCellLayout *layout = [[SWStatusCellLayout alloc] initWithStatusModel:status index:index opend:NO];
        [self.dataSource addObject:layout];
    }
    kDISPATCH_MAIN_THREAD(^{
        [self.tableView reloadData];
    })
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWStatusCellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIdentifier";
    SWStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SWStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self tapView:nil];
    SWStatusCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.menu menuHide];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)confirgueCell:(SWStatusCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    SWStatusCellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
//    [self callbackWithCell:cell];
}


//#pragma mark - QMUINavigationControllerDelegate
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}
//
//- (UIImage *)navigationBarBackgroundImage {
//    return UIImageMake(@"navigationbar_background");
//}
//
//- (UIImage *)navigationBarShadowImage {
//    return [[UIImage alloc] init];
//}
//
//- (UIColor *)navigationBarTintColor {
//    return UIColorMake(33, 33, 33);
//}
//
//- (UIColor *)titleViewTintColor {
//    return UIColorMake(33, 33, 33);
//}
//
//#pragma mark - NavigationBarTransition
//- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing {
//    return YES;
//}
//
//- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing {
//    return YES;
//}

@end
