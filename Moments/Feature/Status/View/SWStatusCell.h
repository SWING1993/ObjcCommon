//
//  SWStatusCell.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMenu.h"
#import "SWStatusCellLayout.h"

@interface SWStatusCell : UITableViewCell

@property (nonatomic,strong) LWAsyncDisplayView* asyncDisplayView;
//@property (nonatomic,assign) BOOL notNeedLine;
@property (nonatomic,strong) SWMenu* menu;
@property (nonatomic,strong) SWStatusCellLayout* cellLayout;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,copy) void(^clickedImageCallback)(SWStatusCell* cell,NSInteger imageIndex);
@property (nonatomic,copy) void(^clickedLikeButtonCallback)(SWStatusCell* cell);
@property (nonatomic,copy) void(^clickedCommentButtonCallback)(SWStatusCell* cell);
@property (nonatomic,copy) void(^clickedAvatarCallback)(SWStatusCell* cell);
@property (nonatomic,copy) void(^clickedOpenCellCallback)(SWStatusCell* cell);
@property (nonatomic,copy) void(^clickedCloseCellCallback)(SWStatusCell* cell);
@property (nonatomic,copy) void(^clickedDeleteCellCallback)(SWStatusCell* cell);
@property (nonatomic,copy) void(^clickedMenuCallback)(SWStatusCell* cell);

@end
