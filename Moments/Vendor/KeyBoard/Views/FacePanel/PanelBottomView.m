//
//  PanelBottomView.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/31.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import "PanelBottomView.h"
#import "FaceThemeModel.h"
#import "ChatKeyBoardMacroDefine.h"

@implementation PanelBottomView
{
    UIScrollView    *_facePickerView;
    UIButton        *_sendBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.backgroundColor = UIColorWhite;
    _facePickerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-kFacePanelBottomSendWidth, kFacePanelBottomToolBarHeight)];
    [self addSubview:_facePickerView];
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(kScreenW-kFacePanelBottomSendWidth, 0, kFacePanelBottomSendWidth, kFacePanelBottomToolBarHeight);
    _sendBtn.titleLabel.font = UIFontPFMediumMake(17);
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setBackgroundColor:UIColorBlue];
    [_sendBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
}

- (void)loadfaceThemePickerSource:(NSArray *)pickerSource
{
    for (int i = 0; i<pickerSource.count; i++) {
        FaceThemeModel *themeM = pickerSource[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            btn.selected = YES;
            [btn setBackgroundColor:UIColorForBackground];
        } else {
            btn.selected = NO;
            [btn setBackgroundColor:UIColorWhite];
        }
        btn.tag = i+100;
        btn.titleLabel.font = UIFontMake(14);
        [btn setImage:kGetImage(themeM.themeIcon) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorBlue forState:UIControlStateSelected];
        [btn setTitleColor:UIColorRandom forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(subjectPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(i*kFacePanelBottomSendWidth, 0, kFacePanelBottomSendWidth, kFacePanelBottomToolBarHeight);
        [_facePickerView addSubview:btn];
        if (i == pickerSource.count - 1) {
             NSInteger pages = CGRectGetMaxX(btn.frame) / CGRectGetWidth(_facePickerView.frame) + 1;
            _facePickerView.contentSize = CGSizeMake(pages*CGRectGetWidth(_facePickerView.frame), 0);
        }
    }
}

- (void)changeFaceSubjectIndex:(NSInteger)subjectIndex
{
//    [_facePickerView setContentOffset:CGPointMake(subjectIndex*kFacePanelBottomToolBarHeight, 0) animated:YES];
    for (UIView *sub in _facePickerView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn.tag-100 == subjectIndex) {
                btn.selected = YES;
                [btn setBackgroundColor:UIColorForBackground];
            }else {
                btn.selected = NO;
                [btn setBackgroundColor:UIColorWhite];
            }
        }
    }
}

#pragma mark -- 点击事件

- (void)addBtnClick:(UIButton *)sender
{
    if (self.addAction) {
        self.addAction();
    }
}

- (void)sendBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(panelBottomViewSendAction:)]) {
        [self.delegate panelBottomViewSendAction:self];
    }
}

- (void)setBtnClick:(UIButton *)sender
{
    if (self.setAction) {
        self.setAction();
    }
}

- (void)subjectPicBtnClick:(UIButton *)sender
{
    for (UIView *sub in _facePickerView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn == sender) {
                sender.selected = YES;
            }else {
                btn.selected = NO;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(panelBottomView:didPickerFaceSubjectIndex:)]) {
        [self.delegate panelBottomView:self didPickerFaceSubjectIndex:sender.tag-100];
    }
}


@end
