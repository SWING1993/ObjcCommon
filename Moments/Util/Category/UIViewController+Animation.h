//
//  UIViewController+Animation.h
//  MpmPackStone
//
//  Created by 宋国华 on 2018/9/3.
//  Copyright © 2018年 7cm. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 自定义Present转场模仿Push动画 实现<UIViewControllerTransitioningDelegate>
 #pragma mark - UIViewControllerTransitioningDelegate
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
 CMPushAnimation* pushAnimation = [[CMPushAnimation alloc] init];
 return pushAnimation;
 }
 */
@interface CMPushAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@end
/*
 自定义Dismiss转场模仿Pop动画 实现<UIViewControllerTransitioningDelegate>
 #pragma mark - UIViewControllerTransitioningDelegate
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
 CMPopAnimation* popAnimation = [[CMPopAnimation alloc] init];
 return popAnimation;
 }
 */
@interface CMPopAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@end

@interface UIViewController (Animation)<UIViewControllerTransitioningDelegate>

- (void)presentViewController:(UIViewController *)viewControllerToPresent pushAnimation:(BOOL)animation completion:(void (^ __nullable)(void))completion;

@end
