//
//  SWTextViewCell.h
//  Moments
//
//  Created by 宋国华 on 2018/9/11.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWTextViewCell : UITableViewCell

@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic,copy) void(^textValueChangedBlock)(NSString*);

+ (CGFloat)cellHeight;

@end
