//
//  YPNavigationController+Configure.m
//  YPNavigationBarTransition-Example
//
//  Created by Guoyin Lee on 2018/4/25.
//  Copyright © 2018 yiplee. All rights reserved.
//

#import "YPNavigationController+Configure.h"

@implementation YPNavigationController (Configure)

- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    YPNavigationBarConfigurations configurations = YPNavigationBarShow;
    configurations |= YPNavigationBarBackgroundStyleOpaque;
    configurations |= YPNavigationBarBackgroundStyleImage;
    return configurations;
}

- (UIColor *) yp_navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIImage *) yp_navigationBackgroundImageWithIdentifier:(NSString **)identifier {
//    return [UIImage imageNamed:@"purple"];
    return [UIImage qmui_imageWithColor:UIColorMakeX(33)];
}

@end
