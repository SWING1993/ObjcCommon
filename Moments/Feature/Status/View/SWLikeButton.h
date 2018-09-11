//
//  SWLikeButton.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^likeActionBlock)(BOOL isSelectd);

@interface SWLikeButton : UIButton

- (void)likeButtonAnimationCompletion:(likeActionBlock)completion;

@end
