//
//  SWStatus.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWStatusComment.h"

@interface SWStatus : RLMObject
// id
@property NSInteger id;
// 类型：0=图片+文字 1=视频+文字 2=链接+文字
@property NSInteger type;
// 我的
@property BOOL own;
// 部分人可见标志
@property BOOL personal;
// 正文
@property NSString *content;
// 图片数组 jsonarray 格式
@property NSString *images;
// 所在位置
@property NSString *location;
// 发布时间
@property NSString *createdTime;
// 发布人昵称
@property NSString *nickname;
// 发布人头像
@property NSString *avator;

@property NSString *webSiteUrl;
@property NSString *webSiteDesc;
@property NSString *webSiteImage;
// 点赞
@property NSString *likeNames;
// 评论
@property RLMArray<SWStatusComment> *comments;

+ (NSInteger)incrementaID;
+ (NSString *)generateRandomString;
+ (NSString *)saveImage:(UIImage *)image;
+ (UIImage *)getDocumentImageWithName:(NSString *)name;

@end

RLM_ARRAY_TYPE(SWStatus) // 定义RLMArray<RLMUser>

