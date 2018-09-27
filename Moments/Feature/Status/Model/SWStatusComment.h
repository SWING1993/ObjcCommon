//
//  SWStatusComment.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWStatusComment : RLMObject

@property NSString* createdTime;
@property NSString* comment;
@property NSString* fromNickname;
@property NSString* fromAvator;
@property NSString* toNickname;
@property NSString* toAvator;

@end

RLM_ARRAY_TYPE(SWStatusComment) // 定义RLMArray<RLMUser>
