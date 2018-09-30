//
//  SWMessageViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWMessageViewController.h"
#import "SWMessage.h"
#import "SWMessageCell.h"
#import "SWCreateMsgViewController.h"

@interface SWMessageViewController ()<QMUITableViewDelegate, QMUITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) QMUINavigationButton *discoverBtn;
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) NSMutableArray <SWMessage *>*dataSource;

@end

@implementation SWMessageViewController

- (void)initSubviews {
    [super initSubviews];
    [self setTitle:@"消息"];
    self.discoverBtn = [[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeBack title:@"朋友圈"];
    @weakify(self)
    [self.discoverBtn bk_addEventHandler:^(id sender) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[QMUITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.estimatedRowHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = UIColorWhite;
    self.tableView.separatorColor = UIColorSeparator;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RLMResults *allMessage = [SWMessage allObjects];
    self.dataSource = [NSMutableArray arrayWithCapacity:allMessage.count];
    for (NSInteger index = allMessage.count - 1; index > -1; index --) {
        SWMessage *message = [allMessage objectAtIndex:index];
        [self.dataSource addObject:message];
    }
//    SWMessage *message = [[SWMessage alloc] init];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:UIColorMake(45, 45, 45)];
    self.titleView.tintColor = UIColorWhite;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = UIColorWhite;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = QMUICMI.navBarTintColor;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.discoverBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(rightAction)];
}

- (void)rightAction {
    TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
    @weakify(self)
    [actionSheet addButtonWithTitle:@"添加评论消息" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        SWCreateMsgViewController *controller = [[SWCreateMsgViewController alloc] initWithType:1];
        controller.completeBlock = ^(SWMessage *message) {
            [self savaMessage:message];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"添加点赞消息" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        SWCreateMsgViewController *controller = [[SWCreateMsgViewController alloc] initWithType:0];
        controller.completeBlock = ^(SWMessage *message) {
            [self savaMessage:message];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

- (void)savaMessage:(SWMessage *)message {
    [self.dataSource insertObject:message atIndex:0];
    [self.tableView reloadData];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:message];
    [realm commitWriteTransaction];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SWMessageCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIdentifier";
    SWMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SWMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell configCellWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    UITableViewRowAction *deleteBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        SWMessage *message = self.dataSource[indexPath.row];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:message];
        [realm commitWriteTransaction];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    deleteBtn.backgroundColor = UIColorRed;
    return @[deleteBtn];
}


#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc]initWithString:@"点击清空添加消息" attributes:@{NSFontAttributeName:UIFontPFRegularMake(15),NSForegroundColorAttributeName:UIColorSubTextBlack}];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
