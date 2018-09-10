//
//  MomentsController.h
//  BlackCard
//
//  Created by Song on 2017/5/9.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKFoundIndexModel;

#define kMomentStore @"kMyMomentStore"
#define kMomentTable @"kMyMomentTable"
#define kMomentDataKey @"kMyMomentDataKey"
#define kPublicDataKey @"kMyPublicDataKey"
#define kFailedMomentKey @"kFailedParameterKey"

@interface MomentsController : UIViewController

@property (nonatomic, strong) HKFoundIndexModel *essayIndex;

@end
