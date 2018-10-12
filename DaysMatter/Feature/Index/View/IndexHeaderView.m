//
//  IndexHeaderView.m
//  Moments
//
//  Created by 宋国华 on 2018/10/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "IndexHeaderView.h"

@implementation IndexHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        
        UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT)];
        displayView.backgroundColor = UIColorMake(46, 49, 50);
        [self addSubview:displayView];
        
        self.bg = [[UIImageView alloc] init];
        self.bg.userInteractionEnabled = YES;
        self.bg.image = UIImageMake(@"bg.jpg");
        self.bg.contentMode = UIViewContentModeScaleAspectFill;
        self.bg.frame = CGRectMake(0.0f, frame.size.height - 20.0f - SCREEN_WIDTH - 50, SCREEN_WIDTH, SCREEN_WIDTH + 50);
        self.bg.clipsToBounds = YES;
        [self addSubview:self.bg];
        
        UIImage *imgMask = [UIImage imageNamed:@"MaskPPAlbum"];
        imgMask = [imgMask stretchableImageWithLeftCapWidth:kScreenW/2 topCapHeight:0];
        UIImageView * imageMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bg.frame.size.height - 45, kScreenW, 45)];
        [imageMask setImage:imgMask];
        [imageMask setContentMode:UIViewContentModeScaleAspectFill];
        [imageMask setClipsToBounds:YES];
        [self.bg addSubview:imageMask];
        
        
        UIView *bgMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bg.qmui_width, self.bg.qmui_height)];
        bgMaskView.backgroundColor = UIColorWhite;
        bgMaskView.alpha = 0.05;
        [self.bg addSubview:bgMaskView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, self.bg.qmui_height - 100, 90, 20)];
        title.textColor = UIColorWhite;
        title.font = UIFontPFMediumMake(20);
        title.text = @"Title";
        [self.bg addSubview:title];
        
    }
    return self;
}

@end
