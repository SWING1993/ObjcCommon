//
//  MomentsController.m
//  BlackCard
//
//  Created by Song on 2017/5/9.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import "MomentsController.h"
#import "TableViewCell.h"
#import "TableViewHeader.h"
#import "CellLayout.h"
#import "CommentModel.h"
#import "MomentUserInfoM.h"
#import "ApproveModel.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "MomentStarView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface MomentsController ()
<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ChatKeyBoardDelegate,
ChatKeyBoardDataSource>
{
    YTKKeyValueStore *_store;
}
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,strong) TableViewHeader* tableViewHeader;
@property (nonatomic,strong) NSIndexPath* lastIndexPath;
@property (nonatomic,strong) CommentModel* postComment;
@property (nonatomic,strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic,assign) BOOL displaysAsynchronously;//是否异步绘制
@property (nonatomic,strong) MJRefreshAutoNormalFooter *mjFooter;
@property (nonatomic,strong) MomentStarView *momentStarView;

@end

const CGFloat kRefreshBoundary = 100.0f;
@implementation MomentsController

#pragma mark - ViewControllerLifeCycle

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        [self getLoaclMomentData];
    })
    [self setupUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([DiscoverManager shared].isNeedRefreshWithMoments) {
        [self fakeDownload];
    }
    
    DDRemoveNotificationObserver();
    DDAddNotification(@selector(momentsUnreadCountNotification:), DiscoverNotificationKey);
    DDAddNotification(@selector(momentsRefreshNotification:), DiscoverRefreshNotification);
    DDAddNotification(@selector(momentsInsertObjNotification:), DiscoverInsertObjNotification);
}

- (void)dealloc {
    DDRemoveNotificationObserver();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self tapView:nil];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self tapView:nil];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self fakeDownload];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tapView:nil];
    TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.menu menuHide];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.essayIndex.momentsUnreadCount > 0) {
        MomentRemindView *remindView = [[MomentRemindView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 66)];
        remindView.contentLabel.text = [NSString stringWithFormat:@"  %ld条新消息",(long)self.essayIndex.momentsUnreadCount];
        if (self.essayIndex.type == 53 || self.essayIndex.type == 55 || self.essayIndex.type == 57) {
            [remindView.headView setImage:[UIImage imageNamed:@"logoNav"]];
        } else {
            if ([NSString isBlankString:self.essayIndex.momentsMsgUserHeadurl]) {
                [remindView.headView setImage:kPlaceholderImage];
            } else {
                [remindView.headView zero_Component:self.essayIndex.momentsMsgUserHeadurl longEdge:0 shortEdge:kUserAvatar_WH placeholderImage:kPlaceholderImage];
            }
        }
        
        @weakify(self)
        [remindView bk_whenTapped:^{
            @strongify(self)
            
            [self tapView:nil];
            //清除发现首页的红点计数
            NSDictionary *dict = @{@"fromFlag":@"1",@"unreadMsgCount":@"0",};
            DDPostNotificationWithObj(kFoundIndexNotification, [dict mj_JSONString]);
            
            HKFriendsCircleMessageListController *controller = [[HKFriendsCircleMessageListController alloc] initWithStyle:HKMessageListStyleFriendsCircle];
            [self.navigationController pushViewController:controller animated:YES];
            self.essayIndex = [[HKFoundIndexModel alloc] init];
            [self.tableView reloadData];
        }];
        return remindView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.essayIndex.momentsUnreadCount > 0) {
        return 66.0f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)confirgueCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.displaysAsynchronously = self.displaysAsynchronously;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    CellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(TableViewCell *)cell {
    __weak typeof(self) weakSelf = self;
    cell.clickedLikeButtonCallback = ^(TableViewCell* cell,BOOL isLike) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell didClickedLikeButtonWithIsLike:isLike];
    };
    
    cell.clickedCommentButtonCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself commentWithCell:cell];
    };
    
    cell.clickedReCommentCallback = ^(TableViewCell* cell,CommentModel* model) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself reCommentWithCell:cell commentModel:model];
    };
    
    cell.clickedOpenCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself openTableViewCell:cell];
    };
    
    cell.clickedCloseCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself closeTableViewCell:cell];
    };
    
    cell.clickedDeleteCellCallback= ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself deleteTableViewCell:cell];
    };
    
    cell.clickedAvatarCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself showAvatarWithCell:cell];
    };
    
    cell.clickedImageCallback = ^(TableViewCell* cell,NSInteger imageIndex) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell showImageBrowserWithImageIndex:imageIndex];
    };
    
    cell.clickedVisibleCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself showVisibleType:cell];
    };
    
    cell.clickedMenuCallback = ^(TableViewCell *cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        if (sself.lastIndexPath != cell.indexPath) {
            [sself tapView:nil];
            TableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:sself.lastIndexPath];
            [lastCell.menu menuHide];
            sself.lastIndexPath = cell.indexPath;
        }
    };
    
    cell.clickedToUserInfoCallback = ^(NSString *userId) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself goToUserDetailControllerWithUserId:userId];
    };
    
    cell.clickedManagerDeleteCallback = ^(TableViewCell *cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself managerDeletetableViewCell:cell];
    };
    
    cell.clickedManagerHideCallback = ^(TableViewCell *cell, BOOL isHide) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell didClickedManagerHideButtonWithIsHide:isHide];
    };
    
    cell.clickedManagerShieldCallback = ^(TableViewCell *cell, BOOL isShield) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell didClickedManagerShieldButtonWithIsShield:isShield];
    };
    
    cell.clickedToLinkPidCallback = ^(NSString *pid) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tapView:nil];
        HKProductDetailController *viewControl = [[HKProductDetailController alloc] initWithPid:pid];
        [AppDelegate pushVC:viewControl];
    };
    
    cell.clickedToLinkURLCallback = ^(NSString *url) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tapView:nil];
        BaseWebController *viewControl = [[BaseWebController alloc] initWithUrl:url];
        [AppDelegate pushVC:viewControl];
    };
    
    cell.clickedToTopicCallback = ^(NSString *topicId) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tapView:nil];
        PublicController *publicC = [[PublicController alloc] init];
        publicC.myType = PublicListTypeTopic;
        publicC.topicID = topicId;
        [AppDelegate pushVC:publicC];
    };
}

#pragma mark - Actions
//开始评论
- (void)commentWithCell:(TableViewCell *)cell  {
    self.postComment = [[CommentModel alloc] init];
    self.postComment.essayId = cell.cellLayout.statusModel.id;
    self.postComment.commentId = @"";
    self.postComment.toUserId = @"";
    self.postComment.toNickname = @"";
    self.postComment.fromUserId = [NSString stringWithFormat:@"%zi",[User sharedManager].id];
    self.postComment.fromNickname = kStringIsEmpty([User sharedManager].nickname)? [User sharedManager].name : [User sharedManager].nickname;
    self.postComment.fromUserHeadurl = [User sharedManager].avatar;
    self.postComment.index = cell.indexPath.row;
    self.chatKeyBoard.placeHolder = @"评论";
    [self.chatKeyBoard keyboardUpforComment];
}

//开始回复评论
- (void)reCommentWithCell:(TableViewCell *)cell commentModel:(CommentModel *)commentModel {
    if ([commentModel.fromUserId integerValue] == [User sharedManager].id) {
        TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
        @weakify(self)
        [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDestructive handler:^(TBActionButton * _Nonnull button) {
            @strongify(self)
            [self deleteCommentWithCommentModel:commentModel];
        }];
        [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
        [actionSheet show];
    } else {
        self.postComment = [[CommentModel alloc] init];
        self.postComment.essayId = cell.cellLayout.statusModel.id;
        self.postComment.commentId = commentModel.id;
        self.postComment.fromNickname = kStringIsEmpty([User sharedManager].nickname)? [User sharedManager].name : [User sharedManager].nickname;
        self.postComment.fromUserHeadurl = [User sharedManager].avatar;
        self.postComment.fromUserId = [NSString stringWithFormat:@"%zi",[User sharedManager].id];
        self.postComment.toNickname = commentModel.fromNickname;
        self.postComment.toUserId = commentModel.fromUserId;
        self.postComment.index = commentModel.index;
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复%@:",self.postComment.toNickname];
        [self.chatKeyBoard keyboardUpforComment];
    }
}

//点击查看大图
- (void)tableViewCell:(TableViewCell *)cell showImageBrowserWithImageIndex:(NSInteger)imageIndex {
    BOOL isImageClass = [[cell.cellLayout.statusModel.images firstObject] isKindOfClass:[UIImage class]] ? YES:NO;
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < cell.cellLayout.statusModel.images.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        if (isImageClass) {
            photo.image = cell.cellLayout.statusModel.images[i];
        } else {
            NSDictionary *imageDict = cell.cellLayout.statusModel.images[i];
            photo.url = [HKConfig fullImageURLWithComponent:imageDict[@"url"]]; // 图片路径
        }
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.showSaveBtn = NO;
    browser.currentPhotoIndex = imageIndex; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

//点击头像
- (void)showAvatarWithCell:(TableViewCell *)cell {
    CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    [self goToUserDetailControllerWithUserId:layout.statusModel.userId];
}


//显示可见范围
- (void)showVisibleType:(TableViewCell *)cell {
    [self tapView:nil];
    CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    VisibleOptionController *visible = [[VisibleOptionController alloc] initWithShow:layout.statusModel.visibleType];
    [self.navigationController pushViewController:visible animated:YES];
}

- (void)goToUserDetailControllerWithUserId:(NSString *)userId {
    if (kStringIsEmpty(userId) == false) {
        [self tapView:nil];
        HKNewUserDetailController *controller = [[HKNewUserDetailController alloc] initWithDetailUserId:userId];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
 延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
- (void)coverScreenshotAndDelayRemoveWithCell:(UITableViewCell *)cell cellHeight:(CGFloat)cellHeight {
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    imgView.frame = CGRectMake(imgView.frame.origin.x,
                               imgView.frame.origin.y,
                               imgView.frame.size.width,
                               cellHeight);
    imgView.contentMode = UIViewContentModeTop;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.28f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
}

//点赞
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithIsLike:(BOOL)isLike {
    if (cell.indexPath.row >= self.dataSource.count) {
        return;
    }
    CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.essayApproves];
    ApproveModel *model = [[ApproveModel alloc] init];
    model.fromUserNickname = kStringIsEmpty([User sharedManager].nickname)? [User sharedManager].name : [User sharedManager].nickname;
    model.fromUserId = [NSString stringWithFormat:@"%zi",[User sharedManager].id];
    model.fromUserHeadurl = [User sharedManager].avatar;
    model.toUserId = layout.statusModel.userId;
    model.essayId = layout.statusModel.id;
    if (isLike) {
        [newLikeList addObject:model];
    } else {
        NSArray* reversedArray = [[layout.statusModel.essayApproves reverseObjectEnumerator] allObjects];
        for (ApproveModel *copyModel in reversedArray) {
            if ([copyModel.fromUserId isEqualToString:model.fromUserId]) {
                NSUInteger index = [layout.statusModel.essayApproves indexOfObject:copyModel];
                DebugLog(@"index:%zi",index);
                [newLikeList removeObjectAtIndex:index];
            }
        }
    }
    MomentEssayModel* statusModel = layout.statusModel;
    statusModel.essayApproves = newLikeList;
    statusModel.approveFlag = isLike;
    layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:layout.cellHeight];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    if (isLike) {
        NSDictionary *params = @{@"userId":@([User sharedManager].id)?:@"", @"essayId":layout.statusModel.id?:@"",@"toUserId":layout.statusModel.userId?:@""};
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essayApprove/insert" params:params Success:^(id result) {
            DebugLog(@"%@",result);
        } Failed:^(NSError *error) {
        }];
    } else {
        NSDictionary *params = @{@"userId":@([User sharedManager].id)?:@"",@"essayId":layout.statusModel.id?:@""};
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essayApprove/delete" params:params Success:^(id result) {
        } Failed:^(NSError *error) {
        }];
    }
}

//展开Cell
- (void)openTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    MomentEssayModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initContentOpendLayoutWithStatusModel:model
                                                                                index:cell.indexPath.row
                                                                        dateFormatter:self.dateFormatter];
    
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

//折叠Cell
- (void)closeTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    MomentEssayModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model
                                                              index:cell.indexPath.row
                                                      dateFormatter:self.dateFormatter];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

// 管理员删除
- (void)managerDeletetableViewCell:(TableViewCell *)cell {
    /*
    ReportController *reportC = [ReportController new];
    reportC.momentM = cell.cellLayout.statusModel;
    reportC.myReportType = EssayDelete;
    UINavigationController *reportN = [[UINavigationController alloc]initWithRootViewController:reportC];
    [self presentViewController:reportN animated:YES completion:NULL];
     */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除吗？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    @weakify(self)
    [alert bk_setHandler:^{
        @strongify(self)
        CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
        MomentEssayModel* model = layout.statusModel;
        [self.dataSource removeObjectAtIndex:cell.indexPath.row];
        [self.tableView reloadData];
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/adminDelete" params:@{@"userId":model.userId,@"essayId":model.id,@"delTypeFlag":@"0",@"delNote":@""} Success:^(id result) {
        } Failed:^(NSError *error) {
        }];
    } forButtonAtIndex:1];
    [alert show];
}

//管理员隐藏
- (void)tableViewCell:(TableViewCell *)cell didClickedManagerHideButtonWithIsHide:(BOOL)isHide {
    CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    MomentEssayModel* statusModel = layout.statusModel;
    statusModel.hideFlag = isHide;
    layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:layout.cellHeight];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    NSDictionary *params = @{@"userId":@([User sharedManager].id)?:@"", @"essayId":layout.statusModel.id?:@""};
    if (isHide) {
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/hideEssay" params:params Success:^(id result) {
            DebugLog(@"%@",result);
        } Failed:^(NSError *error) {
        }];
    } else {
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/cancelHideEssay" params:params Success:^(id result) {
            DebugLog(@"%@",result);
        } Failed:^(NSError *error) {
        }];
    }
}

//管理员屏蔽 && 取消屏蔽
- (void)tableViewCell:(TableViewCell *)cell didClickedManagerShieldButtonWithIsShield:(BOOL)isShield {
    if (isShield) {
        TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
        actionSheet.title = @"请选择屏蔽时长";
        @weakify(self)
        [actionSheet addButtonWithTitle:@"30天" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            @strongify(self)
            [self managerShieldWithShieldDays:@"30" tableViewCell:cell withIsShield:isShield];
        }];
        [actionSheet addButtonWithTitle:@"90天" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            @strongify(self)
            [self managerShieldWithShieldDays:@"90" tableViewCell:cell withIsShield:isShield];
        }];
        [actionSheet addButtonWithTitle:@"180天" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            @strongify(self)
            [self managerShieldWithShieldDays:@"180" tableViewCell:cell withIsShield:isShield];
        }];
        [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
        [actionSheet show];
    } else {
        CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
        MomentEssayModel* statusModel = layout.statusModel;
        statusModel.shieldFlag = isShield;
        layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
        [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:layout.cellHeight];
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationNone];
        NSDictionary *params = @{@"userId":@([User sharedManager].id)?:@"",@"shieldUserId":layout.statusModel.userId?:@""};
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/cancelShieldUser" params:params Success:^(id result) {
            DebugLog(@"%@",result);
        } Failed:^(NSError *error) {
        }];
    }
}

//管理员屏蔽
- (void)managerShieldWithShieldDays:(NSString *)shieldDays tableViewCell:(TableViewCell *)cell withIsShield:(BOOL)isShield {
    CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    MomentEssayModel* statusModel = layout.statusModel;
    statusModel.shieldFlag = isShield;
    layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:layout.cellHeight];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    NSDictionary *params = @{@"userId":@([User sharedManager].id)?:@"", @"essayId":layout.statusModel.id?:@"",@"shieldUserId":layout.statusModel.userId?:@"",@"shieldDays":shieldDays};
    [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/shieldUser" params:params Success:^(id result) {
        DebugLog(@"%@",result);
    } Failed:^(NSError *error) {
    }];
}

//删除心情
- (void)deleteTableViewCell:(TableViewCell *)cell {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除吗？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    @weakify(self)
    [alert bk_setHandler:^{
        @strongify(self)
        CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
        MomentEssayModel* model = layout.statusModel;
        [self.dataSource removeObjectAtIndex:cell.indexPath.row];
        [self.tableView reloadData];
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/delete" params:@{@"userId":model.userId,@"essayId":model.id?:@""} Success:^(id result) {
            [[DiscoverManager shared] resetRefreshStatus];
        } Failed:^(NSError *error) {
        }];
    } forButtonAtIndex:1];
    [alert show];
}

//发表评论
- (void)postCommentWithCommentModel:(CommentModel *)model {
    CellLayout* layout = [self.dataSource objectAtIndex:model.index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.essayComments];
    CommentModel* newComment = model;
    [newCommentLists addObject:newComment];
    MomentEssayModel* statusModel = layout.statusModel;
    statusModel.essayComments = newCommentLists;
    CellLayout* newLayout = [self layoutWithStatusModel:statusModel index:model.index];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:model.index inSection:0]];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    [self.dataSource replaceObjectAtIndex:model.index withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    NSDictionary *params;
    if (kStringIsEmpty(model.commentId) || kStringIsEmpty(model.toUserId)) {
        params = @{@"userId":@([User sharedManager].id),@"essayId":model.essayId?:@"",@"comment":model.comment?:@""};
    } else {
        params = @{@"userId":@([User sharedManager].id),@"essayId":model.essayId?:@"",@"comment":model.comment?:@"",@"commentId":model.commentId?:@"",@"toUserId":model.toUserId?:@""};
    }
    [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essayComment/insert" params:params Success:^(id result) {
        DebugLog(@"essayCommentinsert");
    } Failed:^(NSError *error) {
        
    }];
}

//删除评论
- (void)deleteCommentWithCommentModel:(CommentModel *)model {
    CellLayout* layout = [self.dataSource objectAtIndex:model.index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.essayComments];
    [newCommentLists removeObject:model];
    MomentEssayModel* statusModel = layout.statusModel;
    statusModel.essayComments = newCommentLists;
    CellLayout* newLayout = [self layoutWithStatusModel:statusModel index:model.index];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:model.index inSection:0]];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    [self.dataSource replaceObjectAtIndex:model.index withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    NSDictionary *params = @{@"userId":@([User sharedManager].id)?:@"",@"essayId":model.essayId?:@"",@"commentId":model.id?:@""};
    [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essayComment/delete" params:params Success:^(id result) {
        if ([result[@"success"] boolValue]) {
            DebugLog(@"result:%@",result);
        }
    } Failed:^(NSError *error) {
    }];
}

#pragma mark - NSNotificationCenter
/** 接收大厅的所有未读消息 */
- (void)momentsUnreadCountNotification:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[NSString class]]) {
        NSDictionary *extra = [notification.object mj_JSONObject];
        DebugLog(@"___extra:%@",extra);
        if ([extra[@"fromFlag"] intValue] == 1) {
            self.essayIndex = [[HKFoundIndexModel alloc] init];
            self.essayIndex.hallUnreadCount = [extra[@"unreadMsgCount"] intValue];
            self.essayIndex.hallMsgUserHeadurl = extra[@"fromUserHeadurl"];
            self.essayIndex.type = [extra[@"type"] intValue];
            kDISPATCH_MAIN_THREAD(^{
                [self.tableView reloadData];
            })
        }
    }
}

- (void)momentsRefreshNotification:(NSNotification *)notification {
    [self fakeDownload];
}

- (void)momentsInsertObjNotification:(NSNotification *)notification  {
    if (![notification.object isMemberOfClass:[MomentEssayModel class]]) {
        return;
    }
    MomentEssayModel *insertModel = (MomentEssayModel *)notification.object;
    NSMutableArray *models = [[NSMutableArray alloc] initWithObjects:insertModel, nil];
    for (CellLayout *layout in self.dataSource) {
        [models addObject:layout.statusModel];
    }
    
    NSMutableArray *layouts = [[NSMutableArray alloc] init];
    for (int i = 0; i < models.count; i ++) {
        MomentEssayModel*model = models[i];
        LWLayout* layout = [self layoutWithStatusModel:model index:i];
        [layouts addObject:layout];
    }
    self.dataSource = layouts;
    kDISPATCH_MAIN_THREAD(^{
        [self.tableView reloadData];
    })
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
    CGFloat offset = scrollView.contentOffset.y;
    [self.tableViewHeader loadingViewAnimateWithScrollViewContentOffset:offset];
    if (self.lastIndexPath) {
        TableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
        [cell.menu menuHide];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= -kRefreshBoundary) {
        [self refreshBegin];
    }
}

#pragma mark - Keyboard
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self tapView:nil];
}

- (void)tapView:(id)sender {
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
}

#pragma mark - Data
//模拟下拉刷新
- (void)refreshBegin {
    self.view.userInteractionEnabled = NO;
    [self fakeDownload];
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.view.userInteractionEnabled = YES;
                       });
    }];
}

//下载数据
- (void)fakeDownload {
    if (self.needRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
        @weakify(self)
        [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/momentsIndex" params:@{@"userId":@([User sharedManager].id)} Success:^(id result) {
            @strongify(self)
//            DebugLog(@"/essay/momentsIndex:%@",result);
            if ([result[@"success"] boolValue]) {
                [DiscoverManager shared].momentsRefreshDate = [NSDate date];
                [self.dataSource removeAllObjects];
                [_store putObject:result[@"data"] withId:kMomentDataKey intoTable:kMomentTable];
                NSArray *essayList = result[@"data"][@"essayList"];
                for (NSInteger i = 0; i < essayList.count; i ++) {
                    NSDictionary *essayDict = essayList[i];
                    MomentEssayModel *model = [MomentEssayModel mj_objectWithKeyValues:essayDict];
                    LWLayout* layout = [self layoutWithStatusModel:model index:i];
                    [self.dataSource addObject:layout];
                }
            }
            [self refreshComplete];
            [self appendMomentStar];
        } Failed:^(NSError *error) {
            [self refreshComplete];
            [self appendMomentStar];
        }];
    }
}

- (void)setupLoadMoreDataRequest {
    CellLayout *layout = [self.dataSource lastObject];
    MomentEssayModel *model = layout.statusModel;
    if (!model) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    @weakify(self)
    [[HK_NetAPIClient sharedManager] POSTWithBaseURL:kDiscoverBaseUrl urlString:@"essay/momentsIndex" params:@{@"userId":@([User sharedManager].id),@"lastId":model.id,@"totalSize":@(self.dataSource.count)} Success:^(id result) {
        @strongify(self)
        DebugLog(@"/essay/momentsIndex:%@",result);
        [self.tableView.mj_footer endRefreshing];
        if ([result[@"success"] boolValue]) {
            NSArray *essayList = result[@"data"][@"essayList"];
            for (NSInteger i = 0; i < essayList.count; i ++) {
                NSDictionary *essayDict = essayList[i];
                MomentEssayModel *model = [MomentEssayModel mj_objectWithKeyValues:essayDict];
                LWLayout* layout = [self layoutWithStatusModel:model index:i];
                [self.dataSource addObject:layout];
            }
            if (essayList.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }
    } Failed:^(NSError *error) {
        @strongify(self)
        [self.tableView.mj_footer endRefreshing];
    }];
}

//模拟刷新完成
- (void)refreshComplete {
    [self.tableViewHeader refreshingAnimateStop];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.needRefresh = YES;
    }];
}

- (void)appendMomentStar {
    if (self.dataSource.count > 0) {
        self.tableView.mj_footer = self.mjFooter;
        self.tableView.tableFooterView = nil;
    } else {
        self.tableView.mj_footer = nil;
        self.tableView.tableFooterView = self.momentStarView;
        [self.momentStarView appendMomentStarData];
    }
}

- (CellLayout *)layoutWithStatusModel:(MomentEssayModel *)statusModel index:(NSInteger)index {
    CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel
                                                           index:index
                                                   dateFormatter:self.dateFormatter];
    return layout;
}

- (void)getLoaclMomentData {
    _store = [[YTKKeyValueStore alloc] initDBWithName:kMomentStore];
    [_store createTableWithName:kMomentTable];
    NSDictionary *resultData = [_store getObjectById:kMomentDataKey fromTable:kMomentTable];
    NSArray *essayList = resultData[@"essayList"];
    for (NSInteger i = 0; i < essayList.count; i ++) {
        NSDictionary *essayDict = essayList[i];
        MomentEssayModel *model = [MomentEssayModel mj_objectWithKeyValues:essayDict];
        LWLayout* layout = [self layoutWithStatusModel:model index:i];
        [self.dataSource addObject:layout];
    }
    kDISPATCH_MAIN_THREAD(^{
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        } else {
            if ([DiscoverManager shared].isNeedRefreshWithMoments == NO) {
                [self appendMomentStar];
            }
        }
    })

}

#pragma mark - 发布心情
- (void)addEssayActionSheet {
    [self tapView:nil];
    TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
    @weakify(self)
    [actionSheet addButtonWithTitle:@"拍摄" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePickerController setDelegate:self];
            imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }];
    [actionSheet addButtonWithTitle:@"从手机相册选择" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        [self selectPhotos];
    }];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}
#pragma mark QBImagePickerControllerDelegate
- (void)selectPhotos {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    [self dismissViewControllerAnimated:YES completion:NULL];
    if (assets.count == 0) {
        return;
    }
    NSMutableArray *tempArr = [NSMutableArray new];
    for (PHAsset *asset in assets) {
        PHImageRequestOptions *request = [PHImageRequestOptions new];
        request.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        request.resizeMode = PHImageRequestOptionsResizeModeFast;
        request.synchronous = YES;
        @weakify(self)
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(1920, 1080) contentMode:PHImageContentModeDefault options:request resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result == nil) {
                [NSObject showHudTipStr:@"请先将iCloud照片存储到iPhone"];
                return ;
            } else {
                [tempArr addObject:result];
                if (assets.count == tempArr.count) {
                    @strongify(self)
                    PostEssayM *postM = [[PostEssayM alloc] init];
                    postM.fromFlag = PostEssayMoments;;
                    postM.essayImages = tempArr;
                    PostEssayController *postController = [[PostEssayController alloc] initWithPostEssayM:postM];
                    UINavigationController *postNav = [[UINavigationController alloc]initWithRootViewController:postController];
                    [self presentViewController:postNav animated:YES completion:NULL];
                }
            }
        }];
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate  照相机 或者相册
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *tempImage = [UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]];
    NSArray *images = [NSArray arrayWithObject:tempImage];
    PostEssayM *postM = [[PostEssayM alloc] init];
    postM.fromFlag = PostEssayMoments;
    postM.essayImages = [images mutableCopy];
    PostEssayController *postController = [[PostEssayController alloc] initWithPostEssayM:postM];
    UINavigationController *postNav = [[UINavigationController alloc]initWithRootViewController:postController];
    [self presentViewController:postNav animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 更换背景图
- (void)updateUserBackGroundImg {
    [self tapView:nil];
    TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
    @weakify(self)
    [actionSheet addButtonWithTitle:@"更换相册封面" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        HKChangeCoverImgController *controller = [[HKChangeCoverImgController alloc] init];
        controller.delegateImageSignal = [RACSubject subject];
        @weakify(self)
        [controller.delegateImageSignal subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            UIImage *image = [UIImage imageWithData:x];
            self.tableViewHeader.bg.image = image;
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"查看更多明星大咖" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        HKMomentStarListController *controller = [[HKMomentStarListController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

#pragma mark - Getter

- (void)setupUI {
    self.needRefresh = YES;
    self.displaysAsynchronously = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"朋友圈";
    [self.view addSubview:self.tableView];
    @weakify(self)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"Moment_Post") style:UIBarButtonItemStylePlain actionBlick:^{
        @strongify(self)
        [self addEssayActionSheet];
    }];
    
    [self.navigationController.navigationBar.backItem setTitle:@"发现"];
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kNaviHeigh)
                                              style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.tableViewHeader;
    _tableView.mj_footer = self.mjFooter;
    _tableView.tableFooterView = nil;
    return _tableView;
}

- (MJRefreshAutoNormalFooter *)mjFooter {
    if (_mjFooter) {
        return _mjFooter;
    }
    _mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupLoadMoreDataRequest)];
    [_mjFooter setTitle:@"———— 继续拖动，加载更多 ————" forState:MJRefreshStateIdle];
    [_mjFooter setTitle:@"———— 正在加载 ————" forState:MJRefreshStateRefreshing];
    [_mjFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    return _mjFooter;
}

- (MomentStarView *)momentStarView {
    if (_momentStarView) {
        return _momentStarView;
    }
    _momentStarView = [[MomentStarView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 570)];
    @weakify(self)
    _momentStarView.removeSelfBlock = ^(void) {
        @strongify(self)
        self.tableView.tableFooterView = nil;
    };
    return _momentStarView;
}

- (TableViewHeader *)tableViewHeader {
    if (_tableViewHeader) {
        return _tableViewHeader;
    }
    _tableViewHeader =
    [[TableViewHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                      0.0f,
                                                      SCREEN_WIDTH,
                                                      286)];
    @weakify(self)
    [_tableViewHeader.bg bk_whenTapped:^{
        @strongify(self)
        [self updateUserBackGroundImg];
    }];
    [_tableViewHeader.avtar bk_whenTapped:^{
        @strongify(self)
        NSString *str_id = [NSString stringWithFormat:@"%@",@([User sharedManager].id)];
        [self goToUserDetailControllerWithUserId:str_id];
    }];
    return _tableViewHeader;
}

- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
    return _dataSource;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    });
    return dateFormatter;
}

- (CommentModel *)postComment {
    if (_postComment) {
        return _postComment;
    }
    _postComment = [[CommentModel alloc] init];
    return _postComment;
}

- (ChatKeyBoard *)chatKeyBoard {
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

- (void)chatKeyBoardSendText:(NSString *)text {
    if ([text isEmptyString]) {
        return;
    }
    self.postComment.comment = text;
    [self postCommentWithCommentModel:self.postComment];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
}
- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey {
    
}
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard {
    
}

- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard {
    
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

@end
