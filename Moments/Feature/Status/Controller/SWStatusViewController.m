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
#import "SWAuthorViewController.h"
#import "SWStatusHeaderView.h"
#import "SWUser.h"
#import "SWAuthorAddViewController.h"
#import "SWStatusCommentViewController.h"
#import "SWStatusLinkViewController.h"
#import "SWStatusDetailViewController.h"

@interface SWStatusViewController () <QMUITableViewDelegate, QMUITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) SWStatusHeaderView* tableViewHeader;
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) NSMutableArray <SWStatusCellLayout *>*dataSource;
@property (nonatomic, strong) NSIndexPath* lastIndexPath;
@property (nonatomic, strong) SWUser *user;
@property (nonatomic, assign) CGFloat minAlphaOffset;
@property (nonatomic, assign) CGFloat maxAlphaOffset;
@property (nonatomic, assign) CGFloat kRefreshBoundary;

@end

@implementation SWStatusViewController {
    CGFloat _gradientProgress;
}

- (void)initSubviews {
    [super initSubviews];
    [self setTitle:@"朋友圈"];
    self.tableView = [[QMUITableView alloc] initWithFrame:kScreenBounds
                                                    style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.estimatedRowHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableViewHeader;
    self.tableView.backgroundColor = UIColorWhite;
    [self.view addSubview:self.tableView];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"Moment_Post") style:UIBarButtonItemStyleDone target:self action:@selector(postStatusAction)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUserInfo];
    self.minAlphaOffset = SCREEN_WIDTH*0.65 - 2*self.qmui_navigationBarMaxYInViewCoordinator;
    self.maxAlphaOffset = SCREEN_WIDTH*0.65 - self.qmui_navigationBarMaxYInViewCoordinator;
    self.kRefreshBoundary = self.qmui_navigationBarMaxYInViewCoordinator + 36;
    [self fakeDownloadNotReloadTable:NO];
    DDAddNotification(@selector(fakeDownloadNotReloadTable:), @"newStatusNotification");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
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
    SWStatusCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.menu menuHide];
    SWStatusCellLayout* layout = self.dataSource[indexPath.row];
    SWStatusDetailViewController *controller = [[SWStatusDetailViewController alloc] init];
    controller.status = layout.statusModel;
    [self.navigationController pushViewController:controller animated:YES];
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
        SWStatusCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self deleteTableViewCell:cell];
    }];
    deleteBtn.backgroundColor = UIColorRed;
    return @[deleteBtn];
}

- (void)confirgueCell:(SWStatusCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    SWStatusCellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
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
    
    cell.clickedOpenCellCallback = ^(SWStatusCell* cell) {
        @strongify(self)
        [self openTableViewCell:cell];
    };
    
    cell.clickedCloseCellCallback = ^(SWStatusCell* cell) {
        @strongify(self)
        [self closeTableViewCell:cell];
    };
    
    cell.clickedDeleteCellCallback= ^(SWStatusCell* cell) {
        @strongify(self)
        [self deleteTableViewCell:cell];
    };
    
    cell.clickedMenuCallback = ^(SWStatusCell *cell) {
        @strongify(self)
        if (self.lastIndexPath != cell.indexPath) {
            SWStatusCell *lastCell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
            [lastCell.menu menuHide];
            self.lastIndexPath = cell.indexPath;
        }
    };
}

//点赞cell
- (void)likeTableViewCell:(SWStatusCell *)cell {
    SWAuthorViewController *controller = [[SWAuthorViewController alloc] init];
    controller.allowsMultipleSelection = YES;
    @weakify(self)
    controller.multipleCompleteBlock = ^(NSArray *authors) {
        @strongify(self)
        
        SWStatusCellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
        SWStatus* model = layout.statusModel;
        RLMRealm *realm = [RLMRealm defaultRealm];
        // 更新对象数据
        [realm beginWriteTransaction];
        [model.likes removeAllObjects];
        [model.likes addObjects:authors];
        [realm commitWriteTransaction];

        SWStatusCellLayout* newLayout = [[SWStatusCellLayout alloc] initWithStatusModel:model index:cell.indexPath.row opend:NO];
        [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
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
        SWStatusCellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
        SWStatus* model = layout.statusModel;
        RLMRealm *realm = [RLMRealm defaultRealm];
        // 更新对象数据
        [realm beginWriteTransaction];
        SWStatusComment *statusCcomment = [[SWStatusComment alloc] init];
        statusCcomment.fromAuthor = from;
        statusCcomment.toAuthor = to;
        statusCcomment.comment = comment;
        [model.comments addObject:statusCcomment];
        [realm commitWriteTransaction];
        
        SWStatusCellLayout* newLayout = [[SWStatusCellLayout alloc] initWithStatusModel:model index:cell.indexPath.row opend:NO];
        [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
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
            SWStatusCellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
            SWStatus* model = layout.statusModel;
            RLMRealm *realm = [RLMRealm defaultRealm];
            // 更新对象数据
            [realm beginWriteTransaction];
            SWStatusComment *statusCcomment = [[SWStatusComment alloc] init];
            statusCcomment.fromAuthor = from;
            statusCcomment.toAuthor = to;
            statusCcomment.comment = comment;
            [model.comments addObject:statusCcomment];
            [realm commitWriteTransaction];
            
            SWStatusCellLayout* newLayout = [[SWStatusCellLayout alloc] initWithStatusModel:model index:cell.indexPath.row opend:NO];
            [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
            [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"删除" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [cell.cellLayout.statusModel.comments removeObjectAtIndex:[cell.cellLayout.statusModel.comments indexOfObject:model]];
        [realm commitWriteTransaction];
        SWStatusCellLayout* newLayout = [[SWStatusCellLayout alloc] initWithStatusModel:cell.cellLayout.statusModel index:cell.indexPath.row opend:NO];
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
        [self.tableView reloadData];
    }];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

//展开Cell
- (void)openTableViewCell:(SWStatusCell *)cell {
    SWStatusCellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    SWStatus* model = layout.statusModel;
    SWStatusCellLayout* newLayout = [[SWStatusCellLayout alloc] initWithStatusModel:model index:cell.indexPath.row opend:YES];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

//折叠Cell
- (void)closeTableViewCell:(SWStatusCell *)cell {
    SWStatusCellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    SWStatus* model = layout.statusModel;
    SWStatusCellLayout* newLayout = [[SWStatusCellLayout alloc] initWithStatusModel:model index:cell.indexPath.row opend:NO];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
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
        [realm deleteObject:cell.cellLayout.statusModel];
        [realm commitWriteTransaction];
        [self.dataSource removeObjectAtIndex:cell.indexPath.row];
        [self.tableView reloadData];
    }];
    [alertController addAction:backActioin];
    [alertController addAction:continueAction];
    [alertController showWithAnimated:YES];
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


#pragma mark - Actions
- (void)postStatusAction {
    TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
    @weakify(self)
    [actionSheet addButtonWithTitle:@"视频或图文" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        SWStatusPostViewController *postViewController = [[SWStatusPostViewController alloc] init];
        postViewController.user = self.user;
        [self.navigationController pushViewController:postViewController animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"链接" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        SWStatusLinkViewController *postViewController = [[SWStatusLinkViewController alloc] init];
        postViewController.user = self.user;
        [self.navigationController pushViewController:postViewController animated:YES];
    }];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

- (void)changeHeaderBG {
    TBActionSheet *actionSheet =  [[TBActionSheet alloc] init];
    @weakify(self)
    [actionSheet addButtonWithTitle:@"更换相册封面" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
        @strongify(self)
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        @weakify(self)
        imagePickerController.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
            @strongify(self)
            [picker dismissViewControllerAnimated:YES completion:NULL];
            self.tableViewHeader.bg.image = info[UIImagePickerControllerOriginalImage];
            [[RLMRealm defaultRealm] beginWriteTransaction];
            self.user.bgImageName = [SWStatus saveImage:self.tableViewHeader.bg.image];
            [[RLMRealm defaultRealm] commitWriteTransaction];
        };
    }];
    [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
    [actionSheet show];
}

#pragma mark - Data
//模拟下拉刷新
- (void)refreshBegin {
    self.view.userInteractionEnabled = NO;
    [self fakeDownloadNotReloadTable:YES];
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(self.kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableViewHeader refreshingAnimateBegin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.view.userInteractionEnabled = YES;
                           [self refreshComplete];
                       });
    }];
}

//模拟刷新完成
- (void)refreshComplete {
    [self.tableViewHeader refreshingAnimateStop];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}

- (SWStatusHeaderView *)tableViewHeader {
    if (_tableViewHeader) {
        return _tableViewHeader;
    }
    _tableViewHeader = [[SWStatusHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                      0.0f,
                                                      SCREEN_WIDTH,
                                                      SCREEN_WIDTH*0.65)];
    _tableViewHeader.navHeight = self.qmui_navigationBarMaxYInViewCoordinator;
    @weakify(self)
    [_tableViewHeader.bg bk_whenTapped:^{
        @strongify(self)
        [self changeHeaderBG];
    }];
    [_tableViewHeader.avtar bk_whenTapped:^{
        @strongify(self)
        SWAuthorAddViewController *controller = [[SWAuthorAddViewController alloc] init];
        @weakify(self)
        controller.completeBlock = ^(SWAuthor *author) {
            if (author) {
                @strongify(self)
                [[RLMRealm defaultRealm] beginWriteTransaction];
                if (!kStringIsEmpty(author.nickname)) {
                    self.user.nickname = author.nickname;
                    self.tableViewHeader.nickname.text = author.nickname;
                }
                if (!kStringIsEmpty(author.avatar)) {
                    self.user.avatar = author.avatar;
                    self.tableViewHeader.avtar.image = [SWStatus getDocumentImageWithName:author.avatar];
                }
                [[RLMRealm defaultRealm] addObject:self.user];
                [[RLMRealm defaultRealm] commitWriteTransaction];
            }
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    return _tableViewHeader;
}

- (void)fakeDownloadNotReloadTable:(BOOL)value {
    // 从默认 Realm 中，检索所有的状态
    RLMResults<SWStatus *> *allStatus = [SWStatus allObjects];
    self.dataSource = [NSMutableArray arrayWithCapacity:allStatus.count];
    for (NSInteger index = allStatus.count - 1; index > -1; index --) {
        SWStatus *status = [allStatus objectAtIndex:index];
        SWStatusCellLayout *layout = [[SWStatusCellLayout alloc] initWithStatusModel:status index:index opend:NO];
        [self.dataSource addObject:layout];
    }
    if (self.dataSource.count == 0) {
        NSArray *nicknames = @[@"爱范儿呀",@"可儿",@"煎饼侠",@"Jennifer",@"开心鸭"];
        NSArray *avatars = @[UIImageMake(@"avatar29.jpg"),UIImageMake(@"avatar10.jpg"),UIImageMake(@"avatar32.jpg"),UIImageMake(@"avatar35.jpg"),UIImageMake(@"avatar2.jpg")];
        NSArray *contents = @[@"",@"",@"Zepp DiverCity",@"今日の東京。",@"每一天都很快乐!!!"];
        NSArray *times = @[@"1天前",@"1天前",@"2小时前",@"10分钟前",@"1分钟前"];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (int i = 0; i < nicknames.count; i ++) {
            SWStatus *status = [[SWStatus alloc] init];
            status.id = i;
            status.avator = [SWStatus saveImage:avatars[i]];
            status.nickname = nicknames[i];
            status.content = contents[i];
            status.createdTime = times[i];
            if (i == 0) {
                status.webSiteDesc = @"索尼推出 PS1 迷你复刻主机，你准备好剁手了吗";
                status.type = 2;
            } else if (i == 1) {
                UIImage *image = [UIImage imageNamed:@"WechatIMG5.jpeg"];
                status.images = [@[[SWStatus saveImage:image]] mj_JSONString];
//                status.likeNames = @"路飞,雅静,Jennifer";
                status.type = 1;
            } else if (i == 2) {
                UIImage *image = [UIImage imageNamed:@"WechatIMG6.jpeg"];
                status.images = [@[[SWStatus saveImage:image]] mj_JSONString];
                
            } else if (i == 3) {
                NSMutableArray *imageNames = [NSMutableArray arrayWithCapacity:9];
                for (int z = 0; z < 9; z ++) {
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tokyo%d.jpg",z]];
                    [imageNames addObject:[SWStatus saveImage:image]];
                }
                status.images = [imageNames mj_JSONString];
                status.location = @"日本·东京";
//                status.likeNames = @"雅静,Jennifer,路飞,达孟,蛋儿,茉莉,小薇";
//                SWStatusComment *comment1 = [[SWStatusComment alloc] init];
//                comment1.fromNickname = @"萌萌";
//                comment1.comment = @"Beautiful!!!";
//                [status.comments addObject:comment1];
//                SWStatusComment *comment2 = [[SWStatusComment alloc] init];
//                comment2.fromNickname = @"Jennifer";
//                comment2.toNickname = @"萌萌";
//                comment2.comment = @"thanks...";
//                [status.comments addObject:comment2];
                
            } else if (i == 4) {
//                status.likeNames = @"Queenie,Lana,阿颖";
//                SWStatusComment *comment1 = [[SWStatusComment alloc] init];
//                comment1.fromNickname = @"小鑫鑫";
//                comment1.comment = @"赞";
//                [status.comments addObject:comment1];
            }
            [realm addObject:status];
            SWStatusCellLayout *layout = [[SWStatusCellLayout alloc] initWithStatusModel:status index:i opend:NO];
            [self.dataSource addObject:layout];
        }
        [realm commitWriteTransaction];
    }
    if (!value) {
      [self.tableView reloadData];
    }
}

- (void)configUserInfo {
    // 从默认 Realm 中，检索所有的状态
    RLMResults<SWUser *> *users = [SWUser allObjects];
    self.user = [users firstObject];
    if (!self.user) {
        self.user = [[SWUser alloc] init];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        self.user.nickname = @"开心鸭";
        self.user.avatar = [SWStatus saveImage:UIImageMake(@"avatar2.jpg")];
        [[RLMRealm defaultRealm] addObject:self.user];
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
    if (!kStringIsEmpty(self.user.bgImageName)) {
        self.tableViewHeader.bg.image = [SWStatus getDocumentImageWithName:self.user.bgImageName];
    }
    if (!kStringIsEmpty(self.user.avatar)) {
        self.tableViewHeader.avtar.image = [SWStatus getDocumentImageWithName:self.user.avatar];
    }
    self.tableViewHeader.nickname.text = self.user.nickname;
}


#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc]initWithString:@"点击右上角相机发布朋友圈" attributes:@{NSFontAttributeName:UIFontPFRegularMake(15),NSForegroundColorAttributeName:UIColorSubTextBlack}];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - YPNavigationBarConfigureStyle

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    YPNavigationBarConfigurations configurations = YPNavigationBarShow;
    if (_gradientProgress < 0.5) {
        configurations |= YPNavigationBarStyleBlack;
    }
    if (_gradientProgress == 1) {
        configurations |= YPNavigationBarBackgroundStyleOpaque;
    }
    configurations |= YPNavigationBarBackgroundStyleColor;
    return configurations;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor colorWithWhite:1 - _gradientProgress alpha:1];
}

- (UIColor *) yp_navigationBackgroundColor {
    return [UIColor colorWithWhite:1 alpha:_gradientProgress];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat progress = (offsetY - self.minAlphaOffset) / (self.maxAlphaOffset - self.minAlphaOffset);
    CGFloat gradientProgress = MIN(1, MAX(0, progress));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        [self yp_refreshNavigationBarStyle];
    }
    [self.tableViewHeader loadingViewAnimateWithScrollViewContentOffset:offsetY];
    if (self.lastIndexPath) {
        SWStatusCell *cell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
        [cell.menu menuHide];
    }    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= -self.kRefreshBoundary) {
        [self refreshBegin];
    }
}

- (void)dealloc {
    NSLog(@"newStatusNotification 释放!!!");
    DDRemoveNotificationObserver();
}

@end
