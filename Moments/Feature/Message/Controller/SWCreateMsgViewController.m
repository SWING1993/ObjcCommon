//
//  SWCreateMsgViewController.m
//  Moments
//
//  Created by 宋国华 on 2018/9/29.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "SWCreateMsgViewController.h"
#import "SWAuthorViewController.h"
#import "SWAuthor.h"

@interface XLFormSWAuthorCell : XLFormBaseCell

@end

@implementation XLFormSWAuthorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configure {
    [super configure];
    //override
}

- (void)update {
    [super update];
    // override
    self.textLabel.text = self.rowDescriptor.title;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.rowDescriptor.value) {
        self.detailTextLabel.text = self.rowDescriptor.value[@"nickname"];
        self.detailTextLabel.textColor = UIColorBlack;
    } else {
        self.detailTextLabel.text = @"请选择";
        self.detailTextLabel.textColor = [UIColor grayColor];
    }
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {
    // custom code here
    // i.e new behaviour when cell has been selected
    SWAuthorViewController *authorViewController = [[SWAuthorViewController alloc] init];
    authorViewController.allowsMultipleSelection = NO;
    @weakify(self)
    authorViewController.singleCompleteBlock = ^(SWAuthor *author) {
        @strongify(self)
        self.rowDescriptor.value = @{@"nickname":author.nickname?:@"",@"avatar":author.avatar?:@""};
        [self.formViewController updateFormRow:self.rowDescriptor];
        [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    };
    [controller.navigationController pushViewController:authorViewController animated:YES];
}

@end


@interface SWCreateMsgViewController ()

@property (nonatomic, assign) int type;

@end

@implementation SWCreateMsgViewController

- (instancetype)initWithType:(int)type {
    
    self.type = type;
    
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:self.type == 0 ? @"点赞消息":@"评论消息"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
        
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    // 息发送人
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAuthor rowType:@"XLFormRowDescriptorTypeCustom" title:@"消息发送人"];
    row.cellClass = [XLFormSWAuthorCell class];
    row.cellStyle = UITableViewCellStyleValue1;
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
    
    if (type == 1) {
        // 评论内容
        section = [XLFormSectionDescriptor formSection];
        [formDescriptor addFormSection:section];
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kMessage rowType:XLFormRowDescriptorTypeTextView title:@"评论内容"];
        row.required = YES;
        [row.cellConfigAtConfigure setObject:@"必填" forKey:@"textView.placeholder"];
        [section addFormRow:row];
    }
    
    return [super initWithForm:formDescriptor];
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

    NSDictionary *authorDict = [[self formValues] objectForKey:kAuthor];
    NSString *avatar;
    NSString *nickname;
    if ([authorDict isKindOfClass:[NSDictionary class]]) {
        avatar = authorDict[@"avatar"];
        nickname = authorDict[@"nickname"];
    }
    NSString *time = [[self formValues] objectForKey:kTime];
    UIImage *status = [[self formValues] objectForKey:kStatus];
    NSString *message = [[self formValues] objectForKey:kMessage];

    NSString *errorMessage;
    if (kStringIsEmpty(nickname)) {
        errorMessage = @"消息发布人不能为空";
    }
    if (kStringIsEmpty(message) && self.type == 1) {
        errorMessage = @"评论消息不能为空";
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
    msgObj.avatar = avatar;
    msgObj.nickname = nickname;
    msgObj.createdTime = time;
    msgObj.type = self.type;
    msgObj.contentImage = [SWStatus saveImage:status];
    msgObj.content = message;
    
    if (self.completeBlock) {
        self.completeBlock(msgObj);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
