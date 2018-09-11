//
//  SWStatusLike.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWStatusLike : NSObject

@property (nonatomic,copy) NSString* id;
@property (nonatomic,copy) NSString* essayId;
@property (nonatomic,copy) NSString* created;
@property (nonatomic,copy) NSString* updated;
@property (nonatomic,copy) NSString* fromUserId;
@property (nonatomic,copy) NSString* fromUserHeadurl;
@property (nonatomic,copy) NSString* fromUserNickname;
@property (nonatomic,copy) NSString* toUserId;

@end
