//
//  SWStatusHeaderView.h
//  Moments
//
//  Created by 宋国华 on 2018/9/21.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWStatusHeaderView : UIView

@property (nonatomic, strong) UIImageView *bg;
@property (nonatomic, strong) UIView *avtarBg;
@property (nonatomic, strong) UIImageView *avtar;
@property (nonatomic, strong) UILabel *nickname;

- (void)loadingViewAnimateWithScrollViewContentOffset:(CGFloat)offset;
- (void)refreshingAnimateBegin;
- (void)refreshingAnimateStop;

@end

NS_ASSUME_NONNULL_END
