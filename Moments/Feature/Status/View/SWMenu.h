//
//  SWMenu.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWLikeButton.h"
#import "SWStatus.h"

@interface SWMenu : UIView

@property (nonatomic,strong) SWStatus *statusModel;
@property (nonatomic,strong) SWLikeButton *likeButton;
@property (nonatomic,strong) UIButton *commentButton;

- (void)clickedMenu;
- (void)menuShow;
- (void)menuHide;


@end
