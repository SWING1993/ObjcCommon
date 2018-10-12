//
//  UIColor+layer.m
//  MpmPackStone
//
//  Created by 龚广文 on 2018/9/5.
//  Copyright © 2018年 7cm. All rights reserved.
//

#import "UIColor+layer.h"

@implementation UIColor (layer)

+ (CAGradientLayer *)setGradualChangingColorWithView:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor orientation:(UIColorOrientation)orientation {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor, (__bridge id)toColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    if (orientation == UIColorOrientationHorizontal) {
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    } else {
        gradientLayer.endPoint = CGPointMake(0, 1.0);
    }
    gradientLayer.locations = @[@0, @1];
    return gradientLayer;
}

@end
