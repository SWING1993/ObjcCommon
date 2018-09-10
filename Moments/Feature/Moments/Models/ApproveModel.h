//
//  ApproveModel.h
//  BlackCard
//
//  Created by Song on 2017/5/17.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApproveModel : NSObject
@property (nonatomic,copy) NSString* id;
@property (nonatomic,copy) NSString* essayId;
@property (nonatomic,copy) NSString* created;
@property (nonatomic,copy) NSString* updated;
@property (nonatomic,copy) NSString* fromUserId;
@property (nonatomic,copy) NSString* fromUserHeadurl;
@property (nonatomic,copy) NSString* fromUserNickname;
@property (nonatomic,copy) NSString* toUserId;
@end
