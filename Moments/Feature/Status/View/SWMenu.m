//
//  SWMenu.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWMenu.h"

@interface SWMenu ()

@property (nonatomic,assign) BOOL show;
@property (nonatomic,assign) CGFloat offset;
@property (nonatomic,strong) NSArray *btnArr;

@end

@implementation SWMenu

#pragma mark - LifeCycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.show = NO;
        self.backgroundColor = UIColorClear;
        self.btnArr = [NSArray arrayWithObjects:self.likeButton,self.commentButton, nil];
        self.offset = self.btnArr.count * 80.0f;
        for (UIButton *btn in self.btnArr) {
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
    for (int index = 0; index < self.btnArr.count; index ++) {
        UIButton *btn = self.btnArr[index];
        btn.frame = CGRectMake(index * 80, 0, 80, self.bounds.size.height);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath* beizerPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    [RGBA(76, 81, 84, 1) setFill];
    [beizerPath fill];
    for (int index = 0; index < self.btnArr.count; index ++) {
        if (index != 0) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextMoveToPoint(context, 80.0f*index, 5.0f);
            CGContextAddLineToPoint(context, 80.0f*index, rect.size.height - 5.0f);
            CGContextSetLineWidth(context, 0.5f);
            CGContextSetStrokeColorWithColor(context, RGBA(55, 61, 64, 1).CGColor);
            CGContextStrokePath(context);
        }
    }
}


#pragma mark - Actions
- (void)clickedMenu {
    if (self.show) {
        [self menuHide];
    } else {
        [self menuShow];
    }
}

- (void)menuShow {
    if (self.show) {
        return;
    }
    self.show = YES;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0f
                        options:0
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x - self.offset,
                                                 self.frame.origin.y,
                                                 self.offset,
                                                 34.0f);
                     } completion:^(BOOL finished) {
                     }];
    
}

- (void)menuHide {
    if (!self.show) {
        return;
    }
    self.show = NO;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:0
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x + self.offset,
                                                 self.frame.origin.y,
                                                 0.0f,
                                                 34.0f);
                     } completion:^(BOOL finished) {
                         self.frame = CGRectMake(self.frame.origin.x,
                                                 self.frame.origin.y,
                                                 0.0f,
                                                 34.0f);
                     }];
}

#pragma mark - Getter & Setter

- (SWLikeButton *)likeButton {
    if (_likeButton) {
        return _likeButton;
    }
    _likeButton = [SWLikeButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_likeButton setTitle:@"  赞" forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"likewhite.png"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateHighlighted];
    [_likeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return _likeButton;
}

- (UIButton *)commentButton {
    if (_commentButton) {
        return _commentButton;
    }
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commentButton setTitle:@" 评论" forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"buttonIcon_comment.png"] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"buttonIcon_comment_select"] forState:UIControlStateHighlighted];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return _commentButton;
}

@end
