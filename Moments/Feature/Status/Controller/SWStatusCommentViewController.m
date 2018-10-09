//
//  SWStatusCommentViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/27.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusCommentViewController.h"
#import "SWCreateMsgViewController.h"

@interface SWStatusCommentViewController ()

@end

@implementation SWStatusCommentViewController

- (id)init {
    return [self initWithTo:nil];
}

- (id)initWithTo:(SWAuthor *)to {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"评论"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    // 评论人
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kForm rowType:@"XLFormRowDescriptorTypeCustom" title:@"评论人"];
    row.cellClass = [XLFormSWAuthorCell class];
    row.cellStyle = UITableViewCellStyleValue1;
    [section addFormRow:row];
    
    // 评论对象
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTo rowType:@"XLFormRowDescriptorTypeCustom" title:@"评论对象"];
    row.cellClass = [XLFormSWAuthorCell class];
    row.cellStyle = UITableViewCellStyleValue1;
    if (to) {
        row.value = to;
    }
    [section addFormRow:row];

    // 评论内容
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kComment rowType:XLFormRowDescriptorTypeTextView title:@"评论内容"];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@"必填" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    return [super initWithForm:formDescriptor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorGreen;
    self.tableView.sectionHeaderHeight = 0.01;
    self.tableView.sectionFooterHeight = 20;
    self.tableView.backgroundColor = UIColorForBackground;
    self.tableView.separatorColor = UIColorSeparator;
}


- (void)savePressed:(UIBarButtonItem * __unused)button {
    [self.tableView endEditing:YES];
    
    NSString *comment = [[self formValues] objectForKey:kComment];
    SWAuthor *from = [[self formValues] objectForKey:kForm];
    SWAuthor *to = [[self formValues] objectForKey:kTo];
    NSString *errorMessage;
    if (kStringIsEmpty(comment)) {
        errorMessage = @"回复内容不能为空";
    }
    if (kStringIsEmpty(from.nickname)) {
        errorMessage = @"评论人不能为空";
    }
    if (!kStringIsEmpty(errorMessage)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:errorMessage
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (self.completeBlock) {
        self.completeBlock(from, to, comment);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
