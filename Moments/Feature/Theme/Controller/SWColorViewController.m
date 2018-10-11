//
//  SWColorViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/10/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWColorViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "SWTheme.h"

#define kSpacing 5.0f
#define kThumbnail (kScreenW -3*kSpacing)/4

static NSString *const Identifier = @"CollectionCellIdentifier";

@interface SWColorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SWColorViewController

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *colorSELArr = @[[UIColor flatBlackColor],[UIColor flatBlackColorDark],[UIColor flatBlueColor],[UIColor flatBlueColorDark],[UIColor flatBrownColor],[UIColor flatBrownColorDark],[UIColor flatCoffeeColor],[UIColor flatCoffeeColorDark],[UIColor flatForestGreenColor],[UIColor flatForestGreenColorDark],[UIColor flatGrayColor],[UIColor flatGrayColorDark],[UIColor flatGreenColor],[UIColor flatGreenColorDark],[UIColor flatLimeColor],[UIColor flatLimeColorDark],[UIColor flatMagentaColor],[UIColor flatMagentaColorDark],[UIColor flatMaroonColor],[UIColor flatMaroonColorDark],[UIColor flatMintColor],[UIColor flatMintColorDark],[UIColor flatNavyBlueColor],[UIColor flatNavyBlueColorDark],[UIColor flatOrangeColor],[UIColor flatOrangeColorDark],[UIColor flatPinkColor],[UIColor flatPinkColorDark],[UIColor flatPlumColor],[UIColor flatPlumColorDark],[UIColor flatPowderBlueColor],[UIColor flatPowderBlueColorDark],[UIColor flatPurpleColor],[UIColor flatPurpleColorDark],[UIColor flatRedColor],[UIColor flatRedColorDark],[UIColor flatSandColor],[UIColor flatSandColorDark],[UIColor flatSkyBlueColor],[UIColor flatSkyBlueColorDark],[UIColor flatTealColor],[UIColor flatTealColorDark],[UIColor flatWatermelonColor],[UIColor flatWatermelonColorDark],[UIColor flatWhiteColor],[UIColor flatWhiteColorDark],[UIColor flatYellowColor],[UIColor flatYellowColorDark]];
    
    
    self.dataSource = [NSMutableArray arrayWithCapacity:colorSELArr.count];
    for (int index = 0; index < colorSELArr.count; index ++) {
        UIColor *color = [colorSELArr objectAtIndex:index];
        SWTheme *theme = [[SWTheme alloc] init];
        theme.color = color;
        [self.dataSource addObject:theme];
    }
    [self.collectionView reloadData];
    
}



- (void)setupNavigationItems {
    [super setupNavigationItems];
//    @weakify(self)
//    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] bk_initWithTitle:@"添加" style:UIBarButtonItemStyleDone handler:^(id sender) {
//        @strongify(self)
//        SWAuthorAddViewController *controller = [[SWAuthorAddViewController alloc] init];
//        @weakify(self)
//        controller.completeBlock = ^(SWAuthor *author) {
//            if (author) {
//                @strongify(self)
//                [self.dataSource insertObject:author atIndex:0];
//                [self.collectionView reloadData];
//                RLMRealm *realm = [RLMRealm defaultRealm];
//                [realm beginWriteTransaction];
//                [realm addObject:author];
//                [realm commitWriteTransaction];
//                [[CMAutoTrackerOperation sharedInstance] sendEvent:@"add_author_event"];
//            }
//        };
//        [self.navigationController pushViewController:controller animated:YES];
//    }];
//
//    if (self.allowsMultipleSelection) {
//        UIBarButtonItem *completeBtn = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStyleDone handler:^(id sender) {
//            @strongify(self)
//            NSArray *array = [self.dataSource bk_select:^BOOL(SWAuthor *author) {
//                return author.selected;
//            }];
//            if (self.multipleCompleteBlock) {
//                self.multipleCompleteBlock(array);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        completeBtn.tintColor = UIColorGreen;
//        self.navigationItem.rightBarButtonItems = @[completeBtn, addBtn];
//    } else {
//        self.navigationItem.rightBarButtonItem = addBtn;
//    }
    
}

#pragma mark - UICollectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kSpacing;
        layout.minimumInteritemSpacing = kSpacing;
        layout.itemSize = CGSizeMake(kThumbnail, kThumbnail);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:kScreenBounds collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColorWhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:Identifier];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColorWhite;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    SWTheme *theme = self.dataSource[indexPath.row];
    UIView *themeView = [[UIView alloc] init];
    themeView.backgroundColor = theme.color;
    themeView.layer.cornerRadius = (kThumbnail - 30)/2;
    [cell.contentView addSubview:themeView];
    [themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(kThumbnail - 30);
        make.center.mas_equalTo(cell.contentView);
    }];
    
//    SWAuthor *author = self.dataSource[indexPath.row];
//
//    UIImageView *avator = [[UIImageView alloc] init];
//    avator.image = [SWStatus getDocumentImageWithName:author.avatar];
//    [cell.contentView addSubview:avator];
//    [avator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(cell.contentView);
//        make.height.mas_equalTo(cell.mas_width);
//    }];
//
//    UILabel *nickname = [[UILabel alloc] init];
//    nickname.text = author.nickname;
//    nickname.textAlignment = NSTextAlignmentCenter;
//    nickname.font = UIFontMake(14);
//    [cell.contentView addSubview:nickname];
//    [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(cell.contentView);
//        make.top.mas_equalTo(avator.mas_bottom);
//    }];
    
//    if (self.allowsMultipleSelection) {
//        QMUIButton *btn = [[QMUIButton alloc] init];
//        btn.userInteractionEnabled = NO;
//        btn.tag = indexPath.row;
//        btn.selected = author.selected;
//        [btn setImage:UIImageMake(@"SWAuthor_def") forState:UIControlStateNormal];
//        [btn setImage:UIImageMake(@"SWAuthor_sel") forState:UIControlStateSelected];
//        [cell.contentView addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(35, 35));
//            make.top.right.equalTo(cell.contentView);
//        }];
//    }
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    SWAuthor *author = self.dataSource[indexPath.row];
//    if (self.allowsMultipleSelection) {
//        author.selected = !author.selected;
//        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    } else {
//        if (self.singleCompleteBlock) {
//            self.singleCompleteBlock(author);
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}
@end
