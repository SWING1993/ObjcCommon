//
//  SWStatusSourceViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusSourceViewController.h"

@interface SWStatusSourceViewController ()

@end

@implementation SWStatusSourceViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

-(void)initializeForm {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"填写来源"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Name Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"来自第三方APP的分享会带有来源"];
    [formDescriptor addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSourceName rowType:XLFormRowDescriptorTypeText title:@""];
    [row.cellConfigAtConfigure setObject:@"来源" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentLeft) forKey:@"textField.textAlignment"];
    row.required = YES;
    [section addFormRow:row];
    
    self.form = formDescriptor;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(validateForm)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorGreen;
    
    self.tableView.sectionHeaderHeight = 30;
    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
    self.tableView.backgroundColor = UIColorForBackground;
    self.tableView.separatorColor = UIColorSeparator;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - actions

-(void)validateForm {
    [self.tableView endEditing:YES];
    NSString *source = [[self formValues] objectForKey:kSourceName];
    if (kStringIsEmpty(source)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请填写来源!"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (self.completeBlock) {
        self.completeBlock(source);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
