//
//  SWInstructionsViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/10/9.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWInstructionsViewController.h"
#import "HTTraffic.h"

@interface SWInstructionsViewController ()

@property (nonatomic, strong) QMUITextView* textView;

@end

@implementation SWInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWhite;
    [self setTitle:@"使用说明"];
    [self createFeedbackView];
    
    NSLog(@"HTTraffic:%@",[HTTraffic trafficMonitorings]);

}

- (void)createFeedbackView {
    _textView = [[QMUITextView alloc] initWithFrame:CGRectMake(15, self.qmui_navigationBarMaxYInViewCoordinator, self.view.qmui_width - 30, self.view.qmui_height - self.qmui_navigationBarMaxYInViewCoordinator)];
    _textView.text = @"朋友圈制作器是一款能模仿微信朋友圈的截图生成器。\n\n1.后期会有什么新功能？\n答：本软件只提供微信朋友圈做图功能，后期会不断的完善和增加与朋友圈相关的功能，有什么建议请点击反馈联系我们。";
    _textView.userInteractionEnabled = NO;
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textView];
}

@end
