//
//  SWFeedbackViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/10/9.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWFeedbackViewController.h"


@interface SWFeedbackViewController ()<QMUITextViewDelegate>

@property (nonatomic, strong) QMUITextView* textView;

@end

@implementation SWFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorForBackground;
    [self setTitle:@"反馈"];
    [self createFeedbackView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorGreen;
}

- (void)createFeedbackView {
    _textView = [[QMUITextView alloc] initWithFrame:CGRectMake(0, self.qmui_navigationBarMaxYInViewCoordinator, self.view.qmui_width, 250)];
    _textView.placeholder = @"您的意见和建议会成为我们进步的源动力";
    _textView.delegate = self;
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.layer.borderColor = UIColorSeparator.CGColor;
    _textView.layer.borderWidth = PixelOne;
    [self.view addSubview:_textView];
    [self.textView becomeFirstResponder];
}

- (void)saveAction:(UIButton*)sender {
    if (kStringIsEmpty(self.textView.text)) {
        [QMUITips showInfo:@"请填写您的意见或建议"];
        return;
    }
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"感谢您的意见及建议" message:nil preferredStyle:QMUIAlertControllerStyleAlert];

    @weakify(self)
    QMUIAlertAction *okActioin = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:okActioin];
    [alertController showWithAnimated:YES];
}


@end
