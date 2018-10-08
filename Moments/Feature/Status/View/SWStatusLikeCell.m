//
//  SWStatusLikeCell.m
//  Moments
//
//  Created by 宋国华 on 2018/10/8.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusLikeCell.h"

@interface SWStatusLikeCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UICollectionView *likeCollectionView;

@end

@implementation SWStatusLikeCell

+ (CGFloat)cellHeightWithLikeNum:(NSInteger)num {
    if (num == 0) {
        return CGFLOAT_MIN;
    }
    CGFloat height = 15.0f;
    NSInteger row = floor((kScreenW-62)/37.0f);
    NSInteger total = num/row;
    if (num%row > 0) {
        total += 1;
    }
    height += total *37.0f;
    return height;
}

#pragma mark - Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.likeCollectionView];
    }
    return self;
}

- (void)_layoutSubviews {
    self.bgView.hidden = NO;
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.likeCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
}

- (void)_removeLayoutSubviews {
    self.bgView.hidden = YES;
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    [self.likeCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}

- (void)setStatus:(SWStatus *)status {
    _status = status;
    if (_status.likes.count == 0) {
        [self _removeLayoutSubviews];
    } else {
        [self _layoutSubviews];
        [self.likeCollectionView reloadData];
    }
}

#pragma mark - UICollectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(35.0f, 35.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.status.likes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Identifier" forIndexPath:indexPath];
    for (UIImageView *view in cell.contentView.subviews) {
        if (view.tag == 998) {
            [view removeFromSuperview];
        }
    }
    UIImageView*imageView = [[UIImageView alloc]init];
    [imageView setBackgroundColor:[UIColor clearColor]];
    imageView.tag = 998;
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    SWAuthor *likeAuthor = self.status.likes[indexPath.row];
    imageView.image = [SWStatus getDocumentImageWithName:likeAuthor.avatar];
    [cell.contentView addSubview:imageView];
    return cell;
}

- (UICollectionView *)likeCollectionView {
    if (!_likeCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0f;
        layout.minimumInteritemSpacing = 2.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _likeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _likeCollectionView.backgroundColor = UIColorClear;
        _likeCollectionView.delegate = self;
        _likeCollectionView.dataSource = self;
        _likeCollectionView.showsHorizontalScrollIndicator = NO;
        _likeCollectionView.showsVerticalScrollIndicator = NO;
        _likeCollectionView.scrollEnabled = NO;
        [_likeCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Identifier"];
    }
    return _likeCollectionView;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [kGetImage(@"comment") stretchableImageWithLeftCapWidth:40
                                                                   topCapHeight:15];
        UIImageView *likeIcon = [[UIImageView alloc] initWithImage:kGetImage(@"friend_heart")];
        likeIcon.frame = CGRectMake(12.0f,
                                    15.0f,
                                    13.0f,
                                    13.0f*1.3);
        [_bgView addSubview:likeIcon];
    }
    return _bgView;
}


@end
