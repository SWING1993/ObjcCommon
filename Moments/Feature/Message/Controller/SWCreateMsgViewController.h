//
//  SWCreateMsgViewController.h
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMessage.h"

@interface XLFormSWAuthorCell : XLFormBaseCell

@end

@interface SWCreateMsgViewController : XLFormViewController

@property (nonatomic, copy) void(^completeBlock)(SWMessage *message);

- (instancetype)initWithType:(int)type;

@end

