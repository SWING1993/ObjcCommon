//
//  SWUser.h
//  Moments
//
//  Created by 宋国华 on 2018/9/21.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWUser : RLMObject

@property NSString *bgImageName;
@property NSString *avatar;
@property NSString *nickname;

@end

RLM_ARRAY_TYPE(SWUser) // 定义RLMArray<RLMUser>

