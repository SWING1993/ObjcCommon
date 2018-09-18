//
//  SWStatus.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWStatus : RLMObject
// id
@property NSInteger id;
// 类型：1=文本，2=图片，3=图文 4=视频
@property NSString *type;
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
// 点赞
@property NSString *likeNames;
// 评论
@property (readonly) NSArray *comments;
//// 点赞的人
//@property (readonly) NSArray *essayApproves;

+ (NSInteger)incrementaID;
+ (NSString *)generateRandomString;
+ (NSString *)saveImage:(UIImage *)image;
+ (UIImage *)getDocumentImageWithName:(NSString *)name;

@end

RLM_ARRAY_TYPE(SWStatus) // 定义RLMArray<RLMUser>

