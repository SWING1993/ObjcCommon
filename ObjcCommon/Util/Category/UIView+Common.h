//
//  UIView+Common.h
//  BlackCard
//
//  Created by Mr.song on 16/5/24.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)
// 渐变色
- (CAGradientLayer *)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )aPoint endPoint:(CGPoint)endPoint;
// Shake动画
- (void)addShakeAnimation;
// 抖动动画
- (void)addJitterAnimation;
// 缩放动画
- (void)addScaleAnimation;
// Boom动画
- (void)addBoomAnimationColor:(UIColor *)color;
// 设置单击间隔时长,防止重复点击重复响应
- (void)setClickableafter:(NSTimeInterval)second;
/**
 设置内边框颜色
 
 @param width 边宽
 @param radius 半径
 @param color 色值
 */
- (void)setButtonBorderWidth:(CGFloat)width cornerRadius:(CGFloat)radius borderColor:(UIColor *)color;
@end
