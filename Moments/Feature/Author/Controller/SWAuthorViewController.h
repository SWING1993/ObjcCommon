//
//  SWAuthorViewController.h
//  Moments
//
//  Created by 宋国华 on 2018/9/17.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"
#import "SWAuthor.h"

@interface SWAuthorViewController : SWViewController

@property (nonatomic,copy) void(^singleCompleteBlock)(SWAuthor *author);

@property (nonatomic,copy) void(^multipleCompleteBlock)(NSArray *authors);


/// 控制是否允许多选，默认为NO。
@property(nonatomic, assign) BOOL allowsMultipleSelection;

@end
