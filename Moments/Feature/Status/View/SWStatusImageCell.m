//
//  SWStatusImageCell.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusImageCell.h"

#define kSpacing 5.0f
#define kThumbnail ((kScreenW - 40) -2*kSpacing)/3

static NSString *const Identifier = @"CollectionCellIdentifier";

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong)UIButton *addPhotoBtn;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *deleteBtn;

@end

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!_imageView) {
            _imageView = [[UIImageView alloc]init];
            _imageView.userInteractionEnabled = YES;
            _imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.clipsToBounds = YES;
            [self addSubview:_imageView];
            
            _deleteBtn = [[UIButton alloc]init];
            _deleteBtn.frame = CGRectMake(_imageView.frame.size.width-25, 0, 25, 25);
            [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"moments_删除"] forState:UIControlStateNormal];
            [_imageView addSubview:_deleteBtn];
        }
        
        if (!_addPhotoBtn) {
            _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_addPhotoBtn setImage:[UIImage imageNamed:@"addPic"] forState:UIControlStateNormal];
            _addPhotoBtn.backgroundColor = [UIColor whiteColor];
            _addPhotoBtn.layer.borderColor = UIColorMakeWithRGBA(204, 204, 204, 0.7).CGColor;
            _addPhotoBtn.layer.borderWidth = 1.f;
            _addPhotoBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            _addPhotoBtn.enabled = NO;
            [self addSubview:_addPhotoBtn];
        }
    }
    return self;
}

@end

@interface SWStatusImageCell ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SWStatusImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)setImages:(NSMutableArray *)images {
    _images = images;
    [self.collectionView reloadData];
}

+ (CGFloat)cellHeightWithCount:(NSUInteger)count {
    count ++;
    if (count < 4) {
        return kThumbnail + kSpacing;
    } else if (4 <= count && count <= 6) {
        return (kThumbnail + kSpacing) *2;
    } else {
        return (kThumbnail + kSpacing) *3;
    }
}

#pragma mark - UICollectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kSpacing;
        layout.minimumInteritemSpacing = kSpacing;
        layout.itemSize = CGSizeMake(kThumbnail, kThumbnail);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, kScreenW-40, kScreenW-40) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColorWhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        UILongPressGestureRecognizer *longPresssGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
        [self.collectionView addGestureRecognizer:longPresssGes];
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:Identifier];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(9, self.images.count + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    if (indexPath.row == self.images.count) {
        if (self.images.count < 9) {
            cell.addPhotoBtn.hidden = NO;
            cell.imageView.hidden = YES;
        } else {
            cell.addPhotoBtn.hidden = YES;
            cell.imageView.hidden = NO;
        }
    } else {
        cell.addPhotoBtn.hidden = YES;
        cell.imageView.hidden = NO;
        cell.imageView.image = self.images[indexPath.row];
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.images.count) {
        if (self.addPicturesBlock) {
            self.addPicturesBlock();
        }
    }
    else {
//        NSMutableArray *photoArr = [NSMutableArray new];
//        for (UIImage *image in self.images) {
//            MJPhoto *photo = [[MJPhoto alloc] init];
//            photo.image = image; // 图片路径
//            [photoArr addObject:photo];
//        }
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        browser.showSaveBtn = NO;
//        browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
//        browser.photos = photoArr; // 设置所有的图片
//        [browser show];
    }
}

- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.item != self.images.count) {
        id obj = [self.images objectAtIndex:sourceIndexPath.item];
        [self.images removeObject:obj];
        [self.images insertObject:obj atIndex:destinationIndexPath.item];
    }
    for (int x = 0; x < MIN(9, self.images.count + 1); x ++) {
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:x inSection:0]]];
    }
}

- (void)deletePhoto:(id)sender {
    UIButton *btn = sender;
    NSInteger index = btn.tag;
    if (self.deleteImageBlock) {
        self.deleteImageBlock(index);
    }
}

- (void)longPressMethod:(UILongPressGestureRecognizer *)longPressGes {
    // 判断手势状态
    switch (longPressGes.state) {
            
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPressGes locationInView:self.collectionView]];
            if (indexPath.row < self.images.count) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:[longPressGes locationInView:self.collectionView]];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
            
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(20, 0, kScreenW-40, CGRectGetHeight(self.frame));
}

@end
