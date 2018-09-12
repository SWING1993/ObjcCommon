//
//  SWStatusTimeViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/12.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusTimeViewController.h"

@interface SWStatusTimeViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *valueStr;
@property (nonatomic, strong) NSString *valueStr2;

@end

@implementation SWStatusTimeViewController

// 数据数组的懒加载
- (NSArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 59; i ++) {
            [array addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
        NSArray *titles = @[@"分钟前",@"小时前",@"天前",@"月前",@"年前"];
        _dataSource = @[array,titles];
        _valueStr = [array firstObject];
        _valueStr2 = [titles firstObject];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择发布时间";
    self.contentSizeInPopup = CGSizeMake(kScreenW, 200);
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    [self setupNavigationItems];
}

- (void)setupNavigationItems {
    @weakify(self)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self)
        if (self.completeBlock) {
            self.completeBlock([NSString stringWithFormat:@"%@%@",self.valueStr,self.valueStr2]);
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark UIPickerViewDataSource 数据源方法
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSource.count;
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *items = self.dataSource[component];
    return items.count;
}

#pragma mark UIPickerViewDelegate 代理方法

// 返回每行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataSource[component][row];
}
// 选中行显示在label上
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *items = self.dataSource[component];
    if (component == 0) {
        self.valueStr = items[row];
    } else {
        self.valueStr2 = items[row];
    }
    NSLog(@"%@%@",self.valueStr,self.valueStr2);
}
@end
