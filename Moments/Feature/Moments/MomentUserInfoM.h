//
//  UserInfoM.h
//  BlackCard
//
//  Created by Song on 2017/5/15.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MomentUserInfoM : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *remarkName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *photoBackgroundUrl;
@property (nonatomic, copy) NSArray *urls;
@property (nonatomic, assign) BOOL starFlag;
@property (nonatomic, assign) BOOL groundGlassFlag;
@property (nonatomic, assign) BOOL friendFlag;
@property (nonatomic, assign) BOOL yourself;

@end
