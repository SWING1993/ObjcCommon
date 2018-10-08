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

+ (CGFloat)cellHeightWithStatus:(SWStatus *)status;

@end

