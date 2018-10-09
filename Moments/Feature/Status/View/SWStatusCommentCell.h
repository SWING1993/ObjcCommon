//
//  SWStatusCommentCell.h
//  Moments
//
//  Created by 宋国华 on 2018/10/8.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWStatusCommentCell : UITableViewCell

@property (nonatomic,strong) SWStatus* status;
@property (nonatomic,copy) void(^clickedReCommentCallback)(SWStatusComment* comment);

+ (CGFloat)cellHeightWithStatus:(SWStatus *)status;

@end

