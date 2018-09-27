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
NSString * const kNickname = @"kNickname";
NSString * const kAvator = @"kAvator";

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
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAvator rowType:XLFormRowDescriptorTypeImage title:@"头像"];
    row.value = [UIImage imageNamed:@"default_avatar"];
    [section addFormRow:row];
    self.form = formDescriptor;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(validateForm)];
    
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
        [QMUITips showInfo:@"请填写昵称"];
        return;
    } else if (kStringIsEmpty(self.author.avatar)) {
        [QMUITips showInfo:@"请选择头像"];
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
    } else if ([rowDescriptor.tag isEqualToString:kAvator]){
        self.author.avatar = [SWStatus saveImage:newValue];
    }
}

- (void)dealloc {
    NSLog(@"释放");
}

@end
