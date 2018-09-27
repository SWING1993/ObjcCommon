//
//  SWStatusCommentViewController.h
//  Moments
//
//  Created by 宋国华 on 2018/9/27.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"


@interface SWStatusCommentViewController : XLFormViewController

@property (nonatomic,copy) void(^completeBlock)(NSString*from, NSString*to, NSString*comment);

@end

