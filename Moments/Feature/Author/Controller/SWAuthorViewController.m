//
//  SWAuthorViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/17.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWAuthorViewController.h"
#import "SWAuthorAddViewController.h"

#define kSpacing 5.0f
#define kThumbnail (kScreenW -3*kSpacing)/4

static NSString *const Identifier = @"CollectionCellIdentifier";

@interface SWAuthorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SWAuthorViewController

- (void)initSubviews {
    [super initSubviews];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 从默认 Realm 中，检索所有的状态


    RLMResults *allAuthor = [SWAuthor allObjectsInRealm:[SWRealmConfiguration authorRealm]];
    self.dataSource = [NSMutableArray arrayWithCapacity:allAuthor.count];
    for (NSInteger index = allAuthor.count - 1; index > -1; index --) {
        SWAuthor *author = [allAuthor objectAtIndex:index];
        [self.dataSource addObject:author];
    }
    [self.collectionView reloadData];
    
    
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    @weakify(self)
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] bk_initWithTitle:@"添加" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self)
        SWAuthorAddViewController *controller = [[SWAuthorAddViewController alloc] init];
        @weakify(self)
        controller.completeBlock = ^(SWAuthor *author) {
            if (author) {
                @strongify(self)
                [self.dataSource insertObject:author atIndex:0];
                [self.collectionView reloadData];
                RLMRealm *realm = [SWRealmConfiguration authorRealm];
                [realm beginWriteTransaction];
                [realm addObject:author];
                [realm commitWriteTransaction];
                [[CMAutoTrackerOperation sharedInstance] sendEvent:@"add_author_event"];
            }
        };
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    if (self.allowsMultipleSelection) {
        UIBarButtonItem *completeBtn = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStyleDone handler:^(id sender) {
            @strongify(self)
            NSArray *array = [self.dataSource bk_select:^BOOL(SWAuthor *author) {
                return author.selected;
            }];
            if (self.multipleCompleteBlock) {
                self.multipleCompleteBlock(array);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        completeBtn.tintColor = UIColorGreen;
        self.navigationItem.rightBarButtonItems = @[completeBtn, addBtn];
    } else {
        self.navigationItem.rightBarButtonItem = addBtn;
    }

}

#pragma mark - UICollectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kSpacing;
        layout.minimumInteritemSpacing = kSpacing;
        layout.itemSize = CGSizeMake(kThumbnail, kThumbnail + 20);
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
    cell.contentView.backgroundColor = UIColorForBackground;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    SWAuthor *author = self.dataSource[indexPath.row];
    
    UIImageView *avator = [[UIImageView alloc] init];
    avator.image = [SWStatus getDocumentImageWithName:author.avatar];
    [cell.contentView addSubview:avator];
    [avator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(cell.contentView);
        make.height.mas_equalTo(cell.mas_width);
    }];
    
    UILabel *nickname = [[UILabel alloc] init];
    nickname.text = author.nickname;
    nickname.textAlignment = NSTextAlignmentCenter;
    nickname.font = UIFontMake(14);
    [cell.contentView addSubview:nickname];
    [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(cell.contentView);
        make.top.mas_equalTo(avator.mas_bottom);
    }];
    
    if (self.allowsMultipleSelection) {
        QMUIButton *btn = [[QMUIButton alloc] init];
        btn.userInteractionEnabled = NO;
        btn.tag = indexPath.row;
        btn.selected = author.selected;
        [btn setImage:UIImageMake(@"SWAuthor_def") forState:UIControlStateNormal];
        [btn setImage:UIImageMake(@"SWAuthor_sel") forState:UIControlStateSelected];
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.top.right.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SWAuthor *author = self.dataSource[indexPath.row];
    if (self.allowsMultipleSelection) {
        author.selected = !author.selected;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        if (self.singleCompleteBlock) {
            self.singleCompleteBlock(author);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
