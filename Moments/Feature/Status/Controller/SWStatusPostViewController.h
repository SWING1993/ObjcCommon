//
//  SWStatusPostViewController.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWViewController.h"
#import "SWUser.h"

@interface SWStatusPostViewController : SWViewController<YPNavigationBarConfigureStyle>

@property (nonatomic, strong) SWUser *user;
@property (nonatomic, strong) SWStatus *status;

@end
