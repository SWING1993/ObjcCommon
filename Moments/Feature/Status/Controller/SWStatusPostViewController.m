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
#import "SWStatusTimeViewController.h"
#import "SWStatusLocationViewController.h"
#import "SWAuthorViewController.h"
#import "SWAuthor.h"

@interface SWStatusPostViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>

@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) SWStatus *status;
@property (nonatomic, strong) SWAuthor *author;
@property (nonatomic, strong) NSMutableArray <UIImage *>*originImages;
@property (nonatomic, strong) UISwitch *ownSwitch;
@property (nonatomic, strong) UISwitch *personalSwitch;

@end

static NSString *SWTextViewCellIdentifier = @"SWTextViewCellIdentifier";
static NSString *SWStatusImageCellIdentifier = @"SWStatusImageCellIdentifier";

@implementation SWStatusPostViewController


- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = UIColorWhite;
    
    self.ownSwitch = [[UISwitch alloc] init];
    @weakify(self)
    [[self.ownSwitch rac_newOnChannel] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        self.status.own = [x boolValue];
        [self.tableView reloadData];
    }];
    
    self.personalSwitch = [[UISwitch alloc] init];
    [[self.personalSwitch rac_newOnChannel] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        self.status.personal = [x boolValue];
    }];
    
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
    self.status.createdTime = @"现在";
    self.status.own = YES;
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
    if (kStringIsEmpty(self.status.content) && self.originImages.count == 0) {
        [QMUITips showInfo:@"请填写内容或选择图片"];
        return;
    }
    if (self.originImages.count > 0) {
        NSMutableArray *imageNames = [NSMutableArray arrayWithCapacity:self.originImages.count];
        for (UIImage *image in self.originImages) {
            [imageNames addObject:[SWStatus saveImage:image]];
        }
        self.status.images = [imageNames mj_JSONString];
    }
    if (self.status.own) {
        self.status.nickname = self.user.nickname;
        self.status.avator = self.user.avatar;
    } else {
        if (!self.author) {
            [QMUITips showInfo:@"请选择发布人!"];
            return;
        } else {
            self.status.nickname = self.author.nickname;
            self.status.avator = self.author.avatar;
        }
    }
    self.status.id = [SWStatus incrementaID];
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 通过处理添加数据到 Realm 中
    [realm beginWriteTransaction];
    [realm addObject:self.status];
    [realm commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
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
            return 4;
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
            NSString *cellWithIdentifier = [NSString stringWithFormat:@"section:%zi-row:%zi",indexPath.section,indexPath.row];
            switch (indexPath.row) {
                case 0:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
                        cell.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
                    }
                    cell.textLabel.text = @"所在位置";
                    cell.detailTextLabel.text = kStringIsEmpty(self.status.location) ? @"可不填":self.status.location;
                    return cell;
                }
                    break;
                    
                case 1:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
                        cell.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
                    }
                    cell.textLabel.text = @"发布时间";
                    cell.detailTextLabel.text = self.status.createdTime;
                    return cell;
                }
                    break;
                    
                case 2:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    self.ownSwitch.on = self.status.own;
                    cell.accessoryView = self.ownSwitch;
                    cell.textLabel.text = @"自己发布";
                    return cell;
                }
                    break;
                    
                case 3:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
                    }
                    if (self.status.own) {
                        self.personalSwitch.on = self.status.personal;
                        cell.accessoryView = self.personalSwitch;
                        cell.textLabel.text = @"部分可见";
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.detailTextLabel.text = @"";
                    } else {
                        cell.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
                        cell.textLabel.text = @"发布人";
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.detailTextLabel.text = self.author ? self.author.nickname : @"请选择";
                    }
                    return cell;
                }
                    break;
                    
                    
                case 4:{
                    QMUITableViewCell *cell = (QMUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
                    if (!cell) {
                        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:cellWithIdentifier];
                        cell.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
                    }
                    cell.textLabel.text = @"提醒谁看";
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
    if (indexPath.section != 0) {
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15 hasSectionLine:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView qmui_clearsSelection];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                SWStatusLocationViewController *controller = [[SWStatusLocationViewController alloc] init];
                controller.completeBlock = ^(NSString *valueStr) {
                    self.status.location = valueStr;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
                
            case 1:{
                SWStatusTimeViewController *controller = [[SWStatusTimeViewController alloc] init];
                STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:controller];
                popupController.style = STPopupStyleBottomSheet;
                [popupController presentInViewController:self.navigationController];
                controller.completeBlock = ^(NSString *valueStr) {
                    self.status.createdTime = valueStr;
                    [self.tableView reloadData];
                };
            }
                break;
                
            case 2:{
                
            }
                break;
          
            case 3:{
                SWAuthorViewController *controller = [[SWAuthorViewController alloc] init];
                controller.allowsMultipleSelection = NO;
                @weakify(self)
                controller.singleCompleteBlock = ^(SWAuthor *author) {
                    @strongify(self)
                    self.author = author;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
