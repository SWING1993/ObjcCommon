//
//  UIColor+layer.h
//  MpmPackStone
//
//  Created by 龚广文 on 2018/9/5.
//  Copyright © 2018年 7cm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIColorOrientation) {
    UIColorOrientationHorizontal = 0, //水平方向
    UIColorOrientationVertical = 1,  //垂直方向
};

@interface UIColor (layer)

/**
 设置渐变色

 @param view 视图
 @param fromColor 开始颜色
 @param toColor 结束颜色
 @param orientation 渐变方向
 @return layer
 */
+ (CAGradientLayer *)setGradualChangingColorWithView:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor orientation:(UIColorOrientation)orientation;

@end
