//
//  SWStatusImageCell.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWStatusImageCell : UITableViewCell

@property (copy, nonatomic) NSMutableArray *images;
@property (assign, nonatomic) BOOL video;
@property (copy, nonatomic) void (^addPicturesBlock)(void);
@property (copy, nonatomic) void (^deleteImageBlock)(NSInteger index);

+ (CGFloat)cellHeightWithCount:(NSUInteger)count;

@end
