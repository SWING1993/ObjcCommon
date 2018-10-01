//
//  SWStatusLinkViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/28.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusLinkViewController.h"
#import "SWStatusPostViewController.h"

NSString *const kWebImage = @"webImage";
NSString *const kWebTitle = @"webTitle";

@interface SWStatusLinkViewController ()

@end

@implementation SWStatusLinkViewController

-(id)init {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"链接"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = YES;
    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    // Image
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kWebImage rowType:XLFormRowDescriptorTypeImage title:@"链接封面"];
    row.value = [UIImage imageNamed:@"defaultLink"];
    [section addFormRow:row];
 
    
    // 评论内容
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kWebTitle rowType:XLFormRowDescriptorTypeTextView title:@"链接标题"];
    row.required = YES;
    [row.cellConfigAtConfigure setObject:@"必填,最多显示两行" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    return [super initWithForm:formDescriptor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorGreen;
    self.tableView.tableHeaderView.backgroundColor = UIColorRandom;
    self.tableView.sectionHeaderHeight = 0.01;
    self.tableView.sectionFooterHeight = 20;
    self.tableView.backgroundColor = UIColorForBackground;
    self.tableView.separatorColor = UIColorSeparator;
}


- (void)savePressed:(UIBarButtonItem * __unused)button {
    [self.tableView endEditing:YES];
    NSLog(@"%@",[self formValues]);
    UIImage *webImage = [[self formValues] objectForKey:kWebImage];
    NSString *title = [[self formValues] objectForKey:kWebTitle];


    if (kStringIsEmpty(title)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"链接标题不能为空"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    
    SWStatus *status = [[SWStatus alloc] init];
    status.webSiteDesc = title;
    status.webSiteImage = [SWStatus saveImage:webImage];
    status.type = 2;
    SWStatusPostViewController *postViewController = [[SWStatusPostViewController alloc] init];
    postViewController.user = self.user;
    postViewController.status = status;
    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark YPNavigationBarConfigureStyle
- (YPNavigationBarConfigurations) yp_navigtionBarConfiguration {
    YPNavigationBarConfigurations configurations = YPNavigationBarShow;
    configurations |= YPNavigationBarStyleLight;
    configurations |= YPNavigationBarBackgroundStyleTranslucent;
    configurations |= YPNavigationBarBackgroundStyleColor;
    return configurations;
}

- (UIColor *) yp_navigationBarTintColor {
    return UIColorMakeX(31);
}

- (UIImage *) yp_navigationBackgroundImageWithIdentifier:(NSString **)identifier {
    return [[UIImage imageNamed:@"purple"] resizableImageWithCapInsets:UIEdgeInsetsZero
                                                          resizingMode:UIImageResizingModeStretch];
}

- (UIColor *) yp_navigationBackgroundColor {
    return [UIColorWhite colorWithAlphaComponent:0.95];
}

@end
