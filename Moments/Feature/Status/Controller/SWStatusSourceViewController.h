//
//  SWStatusSourceViewController.h
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWStatusSourceViewController : XLFormViewController

@property (nonatomic,copy) void(^completeBlock)(NSString*valueStr);

@end

NS_ASSUME_NONNULL_END
