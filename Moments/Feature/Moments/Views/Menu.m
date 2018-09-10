
#import "Menu.h"
#import "Gallop.h"

@interface Menu ()

@property (nonatomic,assign) BOOL show;
@property (nonatomic,assign) CGFloat offset;
@property (nonatomic,strong) NSArray *btnArr;

@end

@implementation Menu


#pragma mark - LifeCycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.show = NO;
        self.backgroundColor = [UIColor clearColor];
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
    [UIColorMakeWithRGBA(76, 81, 84, 1) setFill];
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

- (void)setStatusModel:(MomentEssayModel *)statusModel {
    if (_statusModel != statusModel) {
        _statusModel = statusModel;
    }
    if (self.statusModel.approveFlag) {
        [_likeButton setTitle:@" 取消" forState:UIControlStateNormal];
    } else {
        [_likeButton setTitle:@"  赞" forState:UIControlStateNormal];
    }
    if (self.statusModel.hideFlag) {
        [_hideButton setTitle:@"取消隐藏" forState:UIControlStateNormal];
    } else {
        [_hideButton setTitle:@" 隐藏" forState:UIControlStateNormal];
    }
    if (self.statusModel.shieldFlag) {
        [_shieldButton setTitle:@" 取消屏蔽" forState:UIControlStateNormal];
    } else {
        [_shieldButton setTitle:@" 屏蔽" forState:UIControlStateNormal];
    }
}

- (LikeButton *)likeButton {
    if (_likeButton) {
        return _likeButton;
    }
    _likeButton = [LikeButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

- (UIButton *)deleteButton {
    if (_deleteButton) {
        return _deleteButton;
    }
    _deleteButton = [LikeButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteButton setTitle:@" 删除" forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"buttonIcon_delete"] forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"buttonIcon_delete_select"] forState:UIControlStateHighlighted];
    [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return _deleteButton;
}

- (UIButton *)hideButton {
    if (_hideButton) {
        return _hideButton;
    }
    _hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_hideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_hideButton setImage:[UIImage imageNamed:@"buttonIcon_hide"] forState:UIControlStateNormal];
    [_hideButton setImage:[UIImage imageNamed:@"buttonIcon_hide_select"] forState:UIControlStateHighlighted];
    [_hideButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return _hideButton;
}


- (UIButton *)shieldButton {
    if (_shieldButton) {
        return _shieldButton;
    }
    _shieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shieldButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shieldButton setImage:[UIImage imageNamed:@"屏蔽"] forState:UIControlStateNormal];
    [_shieldButton setImage:[UIImage imageNamed:@"屏蔽按住"] forState:UIControlStateHighlighted];
    [_shieldButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return _shieldButton;
}

@end
