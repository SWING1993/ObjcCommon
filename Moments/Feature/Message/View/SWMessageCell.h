//
//  SWMessageCell.h
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "SWMessage.h"

@interface SWMessageCell : QMUITableViewCell

- (void)configCellWithModel:(SWMessage *)message;
+ (CGFloat)cellHeight;
@end


