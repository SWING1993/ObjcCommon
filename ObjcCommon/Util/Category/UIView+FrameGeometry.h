//
//  UIView+FrameGeometry.h
//  MpmMerchant
//
//  Created by Done.L on 2017/10/14.
//  Copyright © 2017年 hz7cm. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (FrameGeometry)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat x;
@property CGFloat y;
@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property CGFloat centerX;
@property CGFloat centerY;

/**
 view切半圆角
 
 @param corner UIRectCorner 可填多个 用 | 隔开
 @param size 圆角大小
 */
- (void)maskToCornerRoundingCorners:(UIRectCorner)corner cornerRedius:(CGSize)size;
@end
