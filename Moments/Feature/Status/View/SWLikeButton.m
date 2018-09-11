//
//  SWLikeButton.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWLikeButton.h"

@implementation SWLikeButton

- (void)likeButtonAnimationCompletion:(likeActionBlock)completion {
    [self setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.imageView.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                                               animations:^{
                                                                   self.imageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                               } completion:^(BOOL finished) {
                                                                   completion(self.isSelected);
                                                                   [self setImage:[UIImage imageNamed:@"likewhite.png"] forState:UIControlStateNormal];
                                                               }];
                                          }];
                     }];
    
}


@end