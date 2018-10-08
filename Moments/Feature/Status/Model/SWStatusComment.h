//
//  SWStatusComment.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWAuthor.h"

@interface SWStatusComment : RLMObject

@property SWAuthor* fromAuthor;
@property SWAuthor* toAuthor;
@property NSString* createdTime;
@property NSString* comment;

@end

RLM_ARRAY_TYPE(SWStatusComment) // 定义RLMArray<RLMUser>
