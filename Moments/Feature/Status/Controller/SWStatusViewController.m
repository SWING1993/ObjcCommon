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
    self.tableView.estimatedRowHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
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
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(SWStatusCell *)cell {
    @weakify(self)
    cell.clickedLikeButtonCallback = ^(SWStatusCell* cell) {
        @strongify(self)
        [self likeTableViewCell:cell];
    };
    
    cell.clickedCommentButtonCallback = ^(SWStatusCell* cell) {
//        @strongify(self)
//        [sself commentWithCell:cell];
    };
    
//    cell.clickedReCommentCallback = ^(SWStatusCell* cell,CommentModel* model) {
//        __strong typeof(weakSelf) sself = weakSelf;
//        [sself reCommentWithCell:cell commentModel:model];
//    };
    
    cell.clickedOpenCellCallback = ^(SWStatusCell* cell) {
        @strongify(self)
        [self openTableViewCell:cell];
    };
    
    cell.clickedCloseCellCallback = ^(SWStatusCell* cell) {
        @strongify(self)
        [self closeTableViewCell:cell];
    };
    
//    cell.clickedDeleteCellCallback= ^(SWStatusCell* cell) {
//        @strongify(self)
//        [self deleteTableViewCell:cell];
//    };
}

//点赞cell
- (void)likeTableViewCell:(SWStatusCell *)cell {
    SWAuthorViewController *controller = [[SWAuthorViewController alloc] init];
    controller.allowsMultipleSelection = YES;
    @weakify(self)
    controller.multipleCompleteBlock = ^(NSArray *authors) {
        @strongify(self)

        NSMutableString *likeNmaes = [[NSMutableString alloc] init];
        for (SWAuthor *author in authors) {
            if (likeNmaes.length == 0) {
                [likeNmaes appendFormat:@"%@",author.nickname];
            } else {
                [likeNmaes appendFormat:@",%@",author.nickname];
            }
        }
        
        SWStatusCellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
        SWStatus* model = layout.statusModel;
        RLMRealm *realm = [RLMRealm defaultRealm];
        // 更新对象数据
        [realm beginWriteTransaction];
        model.likeNames = likeNmaes;
        [realm commitWriteTransaction];

        SWStatusCellLayout* newLayout = [[SWStatusCellLayout alloc] initWithStatusModel:model index:cell.indexPath.row opend:NO];
        [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];

    };
    [self.navigationController pushViewController:controller animated:YES];
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
@end
