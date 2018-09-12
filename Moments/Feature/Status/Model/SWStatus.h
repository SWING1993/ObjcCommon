//
//  SWStatus.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

RLM_ARRAY_TYPE(NSString)

@interface SWStatus : RLMObject

@property NSInteger id;
/** 类型：1=文本，2=图片，3=图文 4=视频 **/
@property NSString *type;
@property BOOL isMine;
@property NSString *content;
// json array 格式
@property NSString *imagesJson;
@property (readonly) NSArray *images;
/** 时间戳 */
@property long long created;
@property NSString *nickname;
@property NSDate *date;
@property NSString *userHeadurl;
/** 点赞标志位，0为当前用户未点赞，1为当前用户已点赞 **/
@property BOOL approveFlag;
/** 点赞数量 */
@property NSInteger approvesCnt;
/** 评论数量 */
@property NSInteger commentsCnt;
@property (readonly) NSArray *essayComments;
@property (readonly) NSArray *essayApproves;

+ (NSString *)generateRandomString;
+ (NSString *)saveImage:(UIImage *)image;
+ (UIImage *)getDocumentImageWithName:(NSString *)name;

@end
