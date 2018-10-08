//
//  SWStatusDetailViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/10/8.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusDetailViewController.h"
#import "SWStatusCell.h"
#import "SWStatusCellLayout.h"
#import "SWStatusLikeCell.h"
#import "SWStatusCommentCell.h"

@interface SWStatusDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) SWStatusCellLayout* cellLayout;

@end

@implementation SWStatusDetailViewController

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(popAction)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColorGreen;
}

- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"详情"];
    [self.view addSubview:self.tableView];
    self.cellLayout = [[SWStatusCellLayout alloc] initWithStatusDetailModel:self.status index:0];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.cellLayout.cellHeight;
    } else if (indexPath.row == 1) {
        return [SWStatusLikeCell cellHeightWithLikeNum:self.status.likes.count];
    } else if (indexPath.row == 2) {
        return [SWStatusCommentCell cellHeightWithStatus:self.status];
    } else {
        return CGFLOAT_MIN;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString* cellIdentifier = @"cellIdentifier";
        SWStatusCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[SWStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.notNeedLine = YES;
        }
        cell.indexPath = indexPath;
        cell.cellLayout = self.cellLayout;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString* likeCellIdentifier = @"likeCellIdentifier";
        SWStatusLikeCell* cell = [tableView dequeueReusableCellWithIdentifier:likeCellIdentifier];
        if (!cell) {
            cell = [[SWStatusLikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:likeCellIdentifier];
        }
        cell.status = self.status;
        return cell;
    } else if (indexPath.row == 2) {
        static NSString* commentCellIdentifier = @"commentCellIdentifier";
        SWStatusCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        if (!cell) {
            cell = [[SWStatusCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdentifier];
        }
        cell.status = self.status;
//        @weakify(self)
//        cell.clickedReCommentCallback = ^(CommentModel *model) {
//            @strongify(self);
//            [self reCommentWithCell:nil commentModel:model];
//        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWStatusCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.menu menuHide];
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds
                                              style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = CGFLOAT_MIN;
    _tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    _tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
    return _tableView;
}
@end
