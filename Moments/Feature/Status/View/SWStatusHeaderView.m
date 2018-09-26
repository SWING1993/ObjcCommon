//
//  SWStatusHeaderView.m
//  Moments
//
//  Created by 宋国华 on 2018/9/21.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusHeaderView.h"

@interface SWStatusHeaderView ()
@property (nonatomic,strong) UIImageView* loadingView;
@end

@implementation SWStatusHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        
        UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -frame.size.height-30, SCREEN_WIDTH,frame.size.height*2)];
        displayView.backgroundColor = UIColorMake(46, 49, 50);
        [self addSubview:displayView];
        [self addSubview:self.loadingView];
        
        self.bg = [[UIImageView alloc] init];
        self.bg.userInteractionEnabled = YES;
        self.bg.image = UIImageMake(@"WechatIMG4.jpeg");
        self.bg.contentMode = UIViewContentModeScaleAspectFill;
        self.bg.frame = CGRectMake(0.0f, displayView.bounds.size.height - SCREEN_WIDTH - 50, SCREEN_WIDTH, SCREEN_WIDTH + 50);
        self.bg.clipsToBounds = YES;
        [displayView addSubview:self.bg];
        
        UIImage *imgMask = [UIImage imageNamed:@"MaskPPAlbum"];
        imgMask = [imgMask stretchableImageWithLeftCapWidth:kScreenW/2 topCapHeight:0];
        UIImageView * imageMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bg.frame.size.height - 45, kScreenW, 45)];
        [imageMask setBackgroundColor:UIColorClear];
        [imageMask setImage:imgMask];
        [imageMask setContentMode:UIViewContentModeScaleAspectFill];
        [imageMask setClipsToBounds:YES];
        [self.bg addSubview:imageMask];
        
        self.avtarBg = [[UIView alloc] init];
        self.avtarBg.frame = CGRectMake(SCREEN_WIDTH - 80.0f, displayView.bounds.size.height - 50.0f, 70.0f, 70.0f);
        self.avtarBg.backgroundColor = UIColorForBackground;
        [displayView addSubview:self.avtarBg];
        
        self.avtar = [[UIImageView alloc] init];
        self.avtar.userInteractionEnabled = YES;
        self.avtar.frame = CGRectMake(0.5f, 0.5f, 69.0f, 69.0f);
        self.avtar.layer.borderColor = UIColorWhite.CGColor;
        self.avtar.layer.borderWidth = 2.5f;
        [self.avtarBg addSubview:self.avtar];
        
        self.nickname = [[UILabel alloc] init];
        self.nickname.font = UIFontPFMediumMake(18);
        self.nickname.textAlignment = NSTextAlignmentRight;
        self.nickname.textColor = UIColorWhite;
        [self.nickname setShadowColor:UIColorMake(33,34,39)];
        [self.nickname setShadowOffset:CGSizeMake(0, 1)];
        self.nickname.frame = CGRectMake(10.0f,displayView.bounds.size.height - 30, SCREEN_WIDTH - 110.0f, 25);
        [displayView addSubview:self.nickname];
    }
    return self;
}

- (UIImageView *)loadingView {
    if (_loadingView) {
        return _loadingView;
    }
    _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f,-100.0f,25.0f,25.0f)];
    _loadingView.contentMode = UIViewContentModeScaleAspectFill;
    _loadingView.image = [UIImage imageNamed:@"loading"];
    _loadingView.clipsToBounds = YES;
    _loadingView.backgroundColor = [UIColor clearColor];
    return _loadingView;
}

- (void)loadingViewAnimateWithScrollViewContentOffset:(CGFloat)offset {
    if (offset <= 0 && offset > - 200.0f) {
        self.loadingView.transform = CGAffineTransformMakeRotation(offset* 0.1);
    }
}

- (void)refreshingAnimateBegin {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimations"];
}

- (void)refreshingAnimateStop {
    [self.loadingView.layer removeAllAnimations];
}

@end
