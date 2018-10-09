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
#import "SWAuthorViewController.h"
#import "SWStatusHeaderView.h"
#import "SWUser.h"
#import "SWAuthorAddViewController.h"
#import "SWStatusCommentViewController.h"
#import "SWStatusLinkViewController.h"
#import "SWStatusDetailViewController.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"

@interface SWStatusDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ChatKeyBoardDataSource>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) SWStatusCellLayout* cellLayout;
@property (nonatomic,strong) ChatKeyBoard *chatKeyBoard;

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
    [self.view addSubview:self.chatKeyBoard];
    [self.view bringSubviewToFront:self.chatKeyBoard];
    self.cellLayout = [[SWStatusCellLayout alloc] initWithStatusDetailModel:self.status index:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
}

-(ChatKeyBoard *)chatKeyBoard {
    if (_chatKeyBoard == nil) {
        _chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.userInteractionEnabled = NO;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
    }
    return _chatKeyBoard;
}

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems {
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems {
    return [FaceSourceManager loadFaceSource];
}

- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems {
    return nil;
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
        [self confirgueCell:cell atIndexPath:indexPath];
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

- (void)confirgueCell:(SWStatusCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.cellLayout = self.cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(SWStatusCell *)cell {
    @weakify(self)
    cell.clickedLikeButtonCallback = ^(SWStatusCell* cell) {
        @strongify(self)
        [self likeTableViewCell:cell];
    };
    
    cell.clickedCommentButtonCallback = ^(SWStatusCell* cell) {
        @strongify(self)
        [self commentWithCell:cell];
    };
    
    cell.clickedReCommentCallback = ^(SWStatusCell* cell,SWStatusComment* model) {
        @strongify(self)
        [self reCommentWithCell:cell commentModel:model];
    };
    
    cell.clickedDeleteCellCallback= ^(SWStatusCell* cell) {
        @strongify(self)
        [self deleteTableViewCell:cell];
    };
}

//点赞cell
- (void)likeTableViewCell:(SWStatusCell *)cell {
    SWAuthorViewController *controller = [[SWAuthorViewController alloc] init];
    controller.allowsMultipleSelection = YES;
    @weakify(self)
    controller.multipleCompleteBlock = ^(NSArray *authors) {
        @strongify(self)
        RLMRealm *realm = [RLMRealm defaultRealm];
        // 更新对象数据
        [realm beginWriteTransaction];
        [self.status.likes removeAllObjects];
        [self.status.likes addObjects:authors];
        [realm commitWriteTransaction];
        
        self.cellLayout = [[SWStatusCellLayout alloc] initWithStatusDetailModel:self.status index:0];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

// 评论cell
- (void)commentWithCell:(SWStatusCell *)cell {
    SWStatusCommentViewController *controller = [[SWStatusCommentViewController alloc] init];
    @weakify(self)
    controller.completeBlock = ^(SWAuthor *from, SWAuthor *to, NSString *comment) {
        @strongify(self)
        RLMRealm *realm = [RLMRealm defaultRealm];
        // 更新对象数据
        [realm beginWriteTransaction];
        SWStatusComment *statusCcomment = [[SWStatusComment alloc] init];
        statusCcomment.fromAuthor = from;
        statusCcomment.toAuthor = to;
        statusCcomment.comment = comment;
        [self.status.comments addObject:statusCcomment];
        [realm commitWriteTransaction];
        
        self.cellLayout = [[SWStatusCellLayout alloc] initWithStatusDetailModel:self.status index:0];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)reCommentWithCell:(SWStatusCell *)cell commentModel:(SWStatusComment *)model {
    TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
    @weakify(self)
    [actionSheet addButtonWithTitle:@"回复" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        SWStatusCommentViewController *controller = [[SWStatusCommentViewController alloc] initWithTo:model.fromAuthor];
        @weakify(self)
        controller.completeBlock = ^(SWAuthor *from, SWAuthor *to, NSString *comment) {
            @strongify(self)
            RLMRealm *realm = [RLMRealm defaultRealm];
            // 更新对象数据
            [realm beginWriteTransaction];
            SWStatusComment *statusCcomment = [[SWStatusComment alloc] init];
            statusCcomment.fromAuthor = from;
            statusCcomment.toAuthor = to;
            statusCcomment.comment = comment;
            [self.status.comments addObject:statusCcomment];
            [realm commitWriteTransaction];
            self.cellLayout = [[SWStatusCellLayout alloc] initWithStatusDetailModel:self.status index:0];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [self.status.comments removeObjectAtIndex:[cell.cellLayout.statusModel.comments indexOfObject:model]];
        [realm commitWriteTransaction];
        self.cellLayout = [[SWStatusCellLayout alloc] initWithStatusDetailModel:self.status index:0];
        [self.tableView reloadData];
    }];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

//删除Cell
- (void)deleteTableViewCell:(SWStatusCell *)cell {
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"确定删除吗?" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
    
    QMUIAlertAction *continueAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    @weakify(self)
    QMUIAlertAction *backActioin = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        @strongify(self)
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:self.status];
        [realm commitWriteTransaction];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:backActioin];
    [alertController addAction:continueAction];
    [alertController showWithAnimated:YES];
}

@end
