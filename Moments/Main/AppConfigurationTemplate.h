//
//  AppConfigurationTemplate.h
//  Moments
//
//  Created by 宋国华 on 2018/9/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorMakeX(x) UIColorMake(x, x, x)
#define UIColorRandom [UIColor qmui_randomColor]
#define UIColorThemeDeepPurple UIColorMake(239, 83, 98) // 主题紫
#define UIColorHighLightColor UIColorMakeWithRGBA(0, 0, 0, 0.15)
#define UIColorTheme1 UIColorMake(239, 83, 98) // Grapefruit
#define UIColorTheme2 UIColorMake(254, 109, 75) // Bittersweet
#define UIColorTheme3 UIColorMake(255, 207, 71) // Sunflower
#define UIColorTheme4 UIColorMake(159, 214, 97) // Grass
#define UIColorTheme5 UIColorMake(63, 208, 173) // Mint
#define UIColorTheme6 UIColorMake(49, 189, 243) // Aqua
#define UIColorTheme7 UIColorMake(90, 154, 239) // Blue Jeans
#define UIColorTheme8 UIColorMake(172, 143, 239) // Lavender
#define UIColorTheme9 UIColorMake(238, 133, 193) // Pink Rose

#define UIFontPFRegularMake(aSize)    [UIFont fontWithName:@"PingFangSC-Regular" size:aSize]
#define UIFontPFMediumMake(aSize)  [UIFont fontWithName:@"PingFangSC-Medium" size:aSize]
#define UIFontPFSemiboldMake(aSize)  [UIFont fontWithName:@"PingFangSC-Semibold" size:aSize]
#define UIFontPFLightMake(aSize)  [UIFont fontWithName:@"PingFangSC-Light" size:aSize]
#define UIFontPFThinMake(aSize)  [UIFont fontWithName:@"PingFangSC-Thin" size:aSize]

#define UIFontHNMake(aSize)  [UIFont fontWithName:@"HelveticaNeue" size:aSize]
#define UIFontHNLightMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Light" size:aSize]
#define UIFontHNMediumMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Medium" size:aSize]
#define UIFontHNBoldMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:aSize]

//弱引用/强引用
#define HKWeakSelf(type)  __weak typeof(type) weak##type = type;
#define HKStrongSelf(type)  __strong typeof(type) type = weak##type;

//设置 view 圆角和边框
#define HKViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//由角度转换弧度 由弧度转换角度
#define HKDegreesToRadian(x) (M_PI * (x) / 180.0)
#define HKRadianToDegrees(radian) (radian*180.0)/(M_PI)

//获取view的frame
#define kGetViewWidth(view)  view.frame.size.width
#define kGetViewHeight(view) view.frame.size.height
#define kGetViewX(view)      view.frame.origin.x
#define kGetViewY(view)      view.frame.origin.y
//获取图片资源的frame
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//沙盒目录文件
//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);

// alertView
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]
//#define kTipAlert(_S_, ...)     [NSObject showHudTipStr:[NSString stringWithFormat:(_S_), ##__VA_ARGS__]]

#define kKeyWindow [UIApplication sharedApplication].keyWindow


#pragma mark - 系统版本  屏幕尺寸
/**
 *  系统版本
 */
#define kDeviceType  [[UIDevice currentDevice] model]
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
#define kDeviceId [HKTools getDeviceIDInKeychain]
#define kVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuild [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define KIdentifier [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

#ifndef ios11x

#endif

#pragma mark - ios系统版本
/**
 *  设备
 */
#define ios11x [kSystemVersion floatValue] >= 11.0f
#define ios10x [kSystemVersion floatValue] >= 10.0f
#define ios9x [kSystemVersion floatValue] >= 9.0f
#define ios8x [kSystemVersion floatValue] >= 8.0f
#define ios7x ([kSystemVersion floatValue] >= 7.0f) && ([kSystemVersion floatValue] < 8.0f)
#define ios6x [kSystemVersion floatValue] < 7.0f
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarHeight 44
#define kNaviHeigh (kNavigationBarHeight+kStatusBarHeight)
#define kTabBarHeight (kDevice_Is_iPhoneX ? 83.0f : 49.0f)

#pragma mark - 屏幕宽高

#define kScaleFrom_iPhone6_Desgin(_X_) (_X_ * (kScreenW/375))
#define kDevice_Is_iPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#pragma mark - 屏幕frame,bounds,size
#define kScreenFrame [UIScreen mainScreen].bounds
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScale [UIScreen mainScreen].scale
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

#define kScreenWidthRatio       (kScreenW < 375 ? kScreenW / 375.0 : 1)
#define kScreenHeightRatio      (kScreenW < 667 ? kScreenH / 667.0 : 1)
#define AdaptedWidth(x)         ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)        ceilf((x) * kScreenHeightRatio)

#pragma mark - Methods
#define BCURL(urlString)    [NSURL URLWithString:urlString]
#define BCNotificationCenter [NSNotificationCenter defaultCenter]
#define BCFileManager        [NSFileManager defaultManager]
#define RGBA(r, g, b ,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#pragma mark - 通知处理
#define DDAddNotification(_selector,_name)\
([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:nil])

#define DDRemoveNotificationWithName(_name)\
([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])

#define DDRemoveNotificationObserver() ([[NSNotificationCenter defaultCenter] removeObserver:self])

#define DDPostNotification(_name)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:nil])

#define DDPostNotificationWithObj(_name,_obj)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:nil])

#define DDPostNotificationWithInfos(_name,_obj,_infos)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:_infos])

// 字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
// 数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
// 字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
// 是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#define kAvatar  @"avatar"
#define kNickname @"nickname"
#define kTime  @"time"
#define kMessage  @"message"
#define kStatus  @"status"
#define kForm  @"form"
#define kTo  @"to"
#define kComment  @"comment"
#define kValidationName  @"first"
#define kValidationEmail  @"second"
#define kSourceName  @"sourceName"
#define kAuthor  @"author"

/**
 *  CMConfigurationTemplate 是一份配置表，用于配合 QMUIConfiguration 来管理整个 App 的全局样式，使用方式：
 *  在 QMUI 项目代码的文件夹里找到 QMUIConfigurationTemplate 目录，把里面所有文件复制到自己项目里，保证能被编译到即可，不需要在某些地方 import，也不需要手动运行。
 *
 *  @warning 更新 QMUIKit 的版本时，请留意 Release Log 里是否有提醒更新配置表，请尽量保持自己项目里的配置表与 QMUIKit 里的配置表一致，避免遗漏新的属性。
 *  @warning 配置表的 class 名必须以 QMUIConfigurationTemplate 开头，并且实现 <QMUIConfigurationTemplateProtocol>，因为这两者是 QMUI 识别该 NSObject 是否为一份配置表的条件。
 *  @warning QMUI 2.3.0 之后，配置表改为自动运行，不需要再在某个地方手动运行了。
 */
@interface AppConfigurationTemplate : NSObject

+ (void)applyConfigurationTemplate;

@end
