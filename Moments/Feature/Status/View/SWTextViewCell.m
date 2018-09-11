//
//  SWTextViewCell.m
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWTextViewCell.h"

@interface SWTextViewCell () <QMUITextViewDelegate>

@end

@implementation SWTextViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        if (_textView == nil) {
            _textView = [[QMUITextView alloc]init];
            _textView.placeholder = @"这一刻的想法 ...";
            _textView.font = [UIFont systemFontOfSize:16.f];
            _textView.textColor = [UIColor blackColor];
            [self.contentView addSubview:_textView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}

+ (CGFloat)cellHeight {
    return 95.0f;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [self.textView becomeFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [self.textView resignFirstResponder];
    return YES;
}


@end
