//
//  SWStatusComment.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWStatusComment : NSObject

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString* id;
@property (nonatomic,copy) NSString* essayId;
@property (nonatomic,copy) NSString* comment;
@property (nonatomic,assign) long long created;
@property (nonatomic,copy) NSString* fromUserId;
@property (nonatomic,copy) NSString* fromNickname;
@property (nonatomic,copy) NSString* fromUserHeadurl;
@property (nonatomic,copy) NSString* toUserId;
@property (nonatomic,copy) NSString* toNickname;
@property (nonatomic,copy) NSString* toUserHeadurl;
@property (nonatomic,copy) NSString* commentId;
@property (nonatomic,assign) NSInteger checkFlag;

@end
