//
//  SWStatusPostViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusPostViewController.h"
#import "SWTextViewCell.h"
#import "SWStatusImageCell.h"
#import "SWStatus.h"

@interface SWStatusPostViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) SWStatus *status;
@property (nonatomic, strong) NSMutableArray <UIImage *>*originImages;

@end

static NSString *SWTextViewCellIdentifier = @"SWTextViewCellIdentifier";
static NSString *SWStatusImageCellIdentifier = @"SWStatusImageCellIdentifier";

@implementation SWStatusPostViewController


- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorWhite;
    self.tableView = [[QMUITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SWTextViewCell class] forCellReuseIdentifier:SWTextViewCellIdentifier];
    [self.tableView registerClass:[SWStatusImageCell class] forCellReuseIdentifier:SWStatusImageCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(savaStatusAction)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.status = [[SWStatus alloc] init];
    self.originImages = [NSMutableArray array];
}

#pragma mark - Actions
- (void)addPictAction {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    @weakify(self)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self)
        self.originImages = [NSMutableArray arrayWithArray:photos];;
        [self.tableView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)savaStatusAction {
    if (self.originImages.count > 0) {
        NSMutableArray *imageNames = [NSMutableArray arrayWithCapacity:self.originImages.count];
        for (UIImage *image in self.originImages) {
            [imageNames addObject:[SWStatus saveImage:image]];
        }
        self.status.imagesJson = [imageNames mj_JSONString];
        NSLog(@"%@",self.status.imagesJson);
    }
    
    // 获取默认的 Realm 存储对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // 通过处理添加数据到 Realm 中
    [realm beginWriteTransaction];
    [realm addObject:self.status];
    [realm commitWriteTransaction];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 2;
        }
            break;
        default:
            return 6;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    return [SWTextViewCell cellHeight];
                    break;
                    
                case 1:
                    return [SWStatusImageCell cellHeightWithCount:self.originImages.count];
                    break;
                    
                default:
                    return 55.0f;
                    break;
            }
        }
            break;
            
        default: {
            return 55.0f;
        }
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:{
                    SWTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SWTextViewCellIdentifier forIndexPath:indexPath];
                    cell.textView.text = self.status.content;
                    @weakify(self)
                    cell.textValueChangedBlock = ^(NSString *valueStr){
                        @strongify(self)
                        self.status.content = valueStr;
                    };
                    return cell;
                }
                    break;
                    
                case 1:{
                    SWStatusImageCell *cell = [tableView dequeueReusableCellWithIdentifier:SWStatusImageCellIdentifier forIndexPath:indexPath];
                    cell.images = self.originImages;
                    @weakify(self)
                    cell.addPicturesBlock = ^(){
                        @strongify(self)
                        [self.view endEditing:YES];
                        [self addPictAction];
                    };
                    cell.deleteImageBlock = ^(NSInteger index) {
                        @strongify(self)
                        [self.originImages removeObjectAtIndex:index];
                        [self.tableView reloadData];
                    };
                    return cell;
                }
                    break;
                    
                default:
                    return nil;
                    break;
            }
        }
            break;
            
        case 1: {
            switch (indexPath.row) {
              
                    
                case 0:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
                        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    }
                    cell.textLabel.text = @"所在位置";
                    return cell;
                }
                    break;
                    
                case 1:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell4"];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell4"];
                        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    }
                    cell.textLabel.text = @"提醒谁看";
                    return cell;
                }
                    break;
                    
                case 2:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell5"];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell5"];
                        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    }
                    cell.textLabel.text = @"发布时间";
                    return cell;
                }
                    break;
                    
                case 3:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"section1cell0"];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"section1cell0"];
                        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    }
                    cell.textLabel.text = @"自己发布";
                    return cell;
                }
                    break;
                    
                case 4:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"section1cell1"];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"section1cell1"];
                        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    }
                    cell.textLabel.text = @"发布人头像";
                    return cell;
                }
                    break;
                    
                case 5:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"section1cell2"];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"section1cell2"];
                        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    }
                    cell.textLabel.text = @"发布人昵称";
                    return cell;
                }
                    break;
                    
                default:
                    return nil;
                    break;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {}else {
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15 hasSectionLine:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - QMUINavigationControllerDelegate

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIImage *)navigationBarBackgroundImage {
    return UIImageMake(@"navig/Users/7cmlg/Desktop/iOSProject/Moments/Moments/Util/Category/UIViewController+Animation.hationbar_background");
}

- (UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

- (UIColor *)navigationBarTintColor {
    return UIColorMake(33, 33, 33);
}

- (UIColor *)titleViewTintColor {
    return UIColorMake(33, 33, 33);
}

#pragma mark - NavigationBarTransition
- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing {
    return YES;
}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing {
    return YES;
}


@end
