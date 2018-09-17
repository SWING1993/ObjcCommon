//
//  SWAuthorAddViewController.h
//  Moments
//
//  Created by 宋国华 on 2018/9/17.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"
#import "SWAuthor.h"

@interface SWAuthorAddViewController : XLFormViewController

@property (nonatomic,copy) void(^completeBlock)(SWAuthor *author);

@end
