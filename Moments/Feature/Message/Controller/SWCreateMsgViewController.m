//
//  SWCreateMsgViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWCreateMsgViewController.h"


@interface SWCreateMsgViewController ()

@end

@implementation SWCreateMsgViewController

- (id)init {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"评论"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    // 消息头像
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAvatar rowType:XLFormRowDescriptorTypeImage title:@"头像"];
    row.value = [UIImage imageNamed:@"defaultHead"];
    [section addFormRow:row];
    
    // 昵称
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kNickname rowType:XLFormRowDescriptorTypeText title:@"昵称"];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@"必填" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    // 时间
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTime rowType:XLFormRowDescriptorTypeEmail title:@"消息时间"];
    [row.cellConfigAtConfigure setObject:@"选填" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    row.value = @"1分钟前";
    [section addFormRow:row];
    
    // 消息封面
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kStatus rowType:XLFormRowDescriptorTypeImage title:@"消息封面"];
    row.value = [UIImage imageNamed:@"defaultHead"];
    row.height = 60.0f;
    
    [section addFormRow:row];
    
    // 评论内容
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMessage rowType:XLFormRowDescriptorTypeTextView title:@"评论内容"];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@"必填" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    return [super initWithForm:formDescriptor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // change cell height of a particular cell
    if ([[self.form formRowAtIndex:indexPath].tag isEqualToString:@"Name"]){
        return 60.0;
    }
    else if ([[self.form formRowAtIndex:indexPath].tag isEqualToString:kStatus]){
        return 100.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorGreen;
    self.tableView.sectionHeaderHeight = 0.01;
    self.tableView.backgroundColor = UIColorForBackground;
    self.tableView.separatorColor = UIColorSeparator;
    self.tableView.estimatedRowHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    self.tableView.estimatedSectionHeaderHeight = CGFLOAT_MIN;
}

- (void)savePressed:(UIBarButtonItem * __unused)button {
    [self.tableView endEditing:YES];

    UIImage *avatar = [[self formValues] objectForKey:kAvatar];
    NSString *nickname = [[self formValues] objectForKey:kNickname];
    NSString *time = [[self formValues] objectForKey:kTime];
    UIImage *status = [[self formValues] objectForKey:kStatus];
    NSString *message = [[self formValues] objectForKey:kMessage];

    
    NSString *errorMessage;
    if (kStringIsEmpty(nickname)) {
        errorMessage = @"昵称不能为空";
    }
    if (kStringIsEmpty(message)) {
        errorMessage = @"回复内容不能为空";
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
    
    SWMessage *msgObj = [[SWMessage alloc] init];
    msgObj.avator = [SWStatus saveImage:avatar];
    msgObj.nickname = nickname;
    msgObj.createdTime = time;
    msgObj.type = 1;
    msgObj.contentImage = [SWStatus saveImage:status];
    msgObj.content = message;
    
    if (self.completeBlock) {
        self.completeBlock(msgObj);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
