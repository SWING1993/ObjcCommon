//
//  SWStatusLocationViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/13.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWStatusLocationViewController.h"

@interface SWStatusLocationViewController ()

@property (nonatomic, copy) NSString *firstValueStr;
@property (nonatomic, copy) NSString *secondValueStr;

@end

@implementation SWStatusLocationViewController
NSString * const kValidationName = @"kFirst";
NSString * const kValidationEmail = @"kSecond";

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

-(void)initializeForm {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"所在位置"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Name Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"所在国家或省市"];
    [formDescriptor addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationName rowType:XLFormRowDescriptorTypeText title:@""];
    [row.cellConfigAtConfigure setObject:@"位置" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentLeft) forKey:@"textField.textAlignment"];
    row.required = YES;
//    row.value = @"Martin";
    [section addFormRow:row];
    
    // Email Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"详情地址"];
    [formDescriptor addFormSection:section];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationEmail rowType:XLFormRowDescriptorTypeText title:@""];
    [row.cellConfigAtConfigure setObject:@"如人民广场" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentLeft) forKey:@"textField.textAlignment"];
    row.required = NO;
    
//    row.value = @"not valid email";
    [row addValidator:[XLFormValidator emailValidator]];
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
    NSArray * array = [self formValidationErrors];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
        if ([validationStatus.rowDescriptor.tag isEqualToString:kValidationName]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            cell.backgroundColor = [UIColor orangeColor];
            [UIView animateWithDuration:0.3 animations:^{
                cell.backgroundColor = [UIColor whiteColor];
            }];
        }
        else if ([validationStatus.rowDescriptor.tag isEqualToString:kValidationEmail]){
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
            [self animateCell:cell];
        }
    }];
}


#pragma mark - Helper

-(void)animateCell:(UITableViewCell *)cell {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    [cell.layer addAnimation:animation forKey:@"shake"];
}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue {
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
    if ([rowDescriptor.tag isEqualToString:kValidationName]){
        self.firstValueStr = newValue;
    } else if ([rowDescriptor.tag isEqualToString:kValidationEmail]){
        self.secondValueStr = newValue;
    }
}

@end
