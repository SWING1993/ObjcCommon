//
//  UIView+GesAdditions.h
//  美平米
//
//  Created by Done.L on 2017/11/20.
//  Copyright © 2017年 com.imicrothink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GesAdditions)

/**
 *  添加点按手势
 */
- (UITapGestureRecognizer *(^)(id,SEL))ges_tap;
/**
 *  添加拖动手势
 */
- (UIPanGestureRecognizer *(^)(id,SEL))ges_pan;
/**
 *  添加捏合手势
 */
- (UIPinchGestureRecognizer *(^)(id,SEL))ges_pinch;
/**
 *  添加旋转手势
 */
- (UIRotationGestureRecognizer *(^)(id,SEL))ges_rotation;
/**
 *  添加长按手势
 */
- (UILongPressGestureRecognizer *(^)(id,SEL))ges_longPress;
/**
 *  添加轻扫手势
 */
- (UISwipeGestureRecognizer *(^)(id,SEL))ges_swipe;

/**
 *  添加手势
 *
 *  @param cls 系统自带或者自定义手势Class
 */
- (id(^)(id,SEL))ges_add:(Class)cls;

/**
 *  移除手势，参数可以是手势实例对象或者手势Class
 */
- (void(^)(id))ges_remove;

/**
 *  移除所有已添加的手势
 */
- (void (^)())ges_removeAll;

@end
