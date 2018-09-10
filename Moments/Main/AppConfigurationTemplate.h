//
//  AppConfigurationTemplate.h
//  Moments
//
//  Created by 宋国华 on 2018/9/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorMakeX(x) UIColorMake(x, x, x)
#define UIColorGray51 UIColorMake(51, 51, 51)
#define UIColorGray119 UIColorMake(119, 119, 119)
#define UIColorGray153 UIColorMake(153, 153, 153)
#define UIColorGray85 UIColorMake(85, 85, 85)

#define UIColorRandom [UIColor qmui_randomColor]
#define UIColorThemeDeepPurple UIColorMake(239, 83, 98) // 主题紫
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
