//
//  SWAuthorAddViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/17.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWAuthorAddViewController.h"

@interface SWAuthorAddViewController ()

@property (nonatomic, strong) SWAuthor *author;

@end

@implementation SWAuthorAddViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeForm];
        self.author = [[SWAuthor alloc] init];
        self.author.id = [SWAuthor incrementaID];
    }
    return self;
}

-(void)initializeForm {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@""];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Name Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"设置昵称和头像"];
    [formDescriptor addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kNickname rowType:XLFormRowDescriptorTypeText title:@"昵称"];
//    [row.cellConfigAtConfigure setObject:@"昵称" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    // Image
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAvatar rowType:XLFormRowDescriptorTypeImage title:@"头像"];
    row.value = [UIImage imageNamed:@"defaultHead"];
    [section addFormRow:row];
    self.form = formDescriptor;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(validateForm)];
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
    if (kStringIsEmpty(self.author.nickname)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请填写昵称!"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    } else if (kStringIsEmpty(self.author.avatar)) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请选择头像!"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (self.completeBlock) {
        self.completeBlock(self.author);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue {
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
    if ([rowDescriptor.tag isEqualToString:kNickname]){
        self.author.nickname = newValue;
    } else if ([rowDescriptor.tag isEqualToString:kAvatar]){
        self.author.avatar = [SWStatus saveImage:newValue];
    }
}

- (void)dealloc {
    NSLog(@"释放");
}

@end
