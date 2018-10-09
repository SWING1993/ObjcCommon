//
//  SWMessage.h
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWMessage : RLMObject

// 评论人
@property SWAuthor *author;
// 类型：0=点赞 1=评论
@property NSInteger type;
// 发布的时间
@property NSString *createdTime;
//评论的状态的图片
@property NSString *contentImage;
// 消息
@property NSString *content;
@end

NS_ASSUME_NONNULL_END
