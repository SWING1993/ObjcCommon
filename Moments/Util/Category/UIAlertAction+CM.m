//
//  UIAlertAction+CM.m
//  MpmMerchant
//
//  Created by 7cmLG on 2018/1/17.
//  Copyright © 2018年 hz7cm. All rights reserved.
//

#import "UIAlertAction+CM.h"

@implementation UIAlertAction (CM)

- (void)setTextColor:(UIColor *)color {
    if (color) {
        uint count = 0;
        Ivar *ivars = class_copyIvarList(self.class, &count);
        for (int i = 0 ; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            if ([[NSString stringWithUTF8String:name] isEqualToString:@"_titleTextColor"]) {
                [self setValue:color forKey:@"_titleTextColor"];
            }
        }
    }
}

@end
