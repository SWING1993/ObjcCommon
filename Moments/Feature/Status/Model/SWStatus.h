//
//  SWStatus.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWStatus : NSObject

@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, copy  ) NSString *content;
@property (nonatomic, strong) NSArray *images;
/** 时间戳 */
@property (nonatomic, assign) long long created;
@property (nonatomic, copy  ) NSString *nickname;
@property (nonatomic, strong) NSDate *date;
/** 类型：1=文本，2=图片，3=图文 4=视频 **/
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, copy  ) NSString *userHeadurl;
/** 点赞标志位，0为当前用户未点赞，1为当前用户已点赞 **/
@property (nonatomic, assign) BOOL approveFlag;

/** 赞数量 */
@property (nonatomic, assign) NSInteger approvesCnt;
/** 评论数量 */
@property (nonatomic, assign) NSInteger commentsCnt;
@property (nonatomic, strong) NSArray *essayComments;
@property (nonatomic, strong) NSArray *essayApproves;

@end
