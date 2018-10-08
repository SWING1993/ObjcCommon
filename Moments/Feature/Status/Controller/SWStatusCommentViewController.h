//
//  SWStatusCommentViewController.h
//  Moments
//
//  Created by 宋国华 on 2018/9/27.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"
#import "SWAuthor.h"

@interface SWStatusCommentViewController : XLFormViewController

@property (nonatomic,copy) void(^completeBlock)(SWAuthor*from, SWAuthor*to, NSString*comment);

@end

