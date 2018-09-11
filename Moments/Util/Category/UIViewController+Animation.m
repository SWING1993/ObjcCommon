//
//  UIViewController+Animation.m
//  MpmPackStone
//
//  Created by 宋国华 on 2018/9/3.
//  Copyright © 2018年 7cm. All rights reserved.
//

#import "UIViewController+Animation.h"

@implementation CMPushAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView* toView = nil;
    UIView* fromView = nil;
    UIView* transView = nil;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    transView = toView;
    [[transitionContext containerView] addSubview:toView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    transView.frame = CGRectMake(width, 0, width, height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        transView.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end


@implementation CMPopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView* toView = nil;
    UIView* fromView = nil;
    UIView* transView = nil;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    transView = fromView;
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    transView.frame = CGRectMake(0, 0, width, height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        transView.frame = CGRectMake(width, 0, width, height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end


@implementation UIViewController (Animation)

- (void)presentViewController:(UIViewController *)viewControllerToPresent pushAnimation:(BOOL)animation completion:(void (^ __nullable)(void))completion {
    if (animation) {
        viewControllerToPresent.transitioningDelegate = self;
    }
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

#pragma mark - UIViewControllerTransitioningDelegate
// push动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    CMPushAnimation* pushAnimation = [[CMPushAnimation alloc] init];
    return pushAnimation;
}
// pop动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    CMPopAnimation* popAnimation = [[CMPopAnimation alloc] init];
    return popAnimation;
}

@end
