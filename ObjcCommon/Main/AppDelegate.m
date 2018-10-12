//
//  AppDelegate.m
//  Moments
//
//  Created by 宋国华 on 2018/9/10.
//  Copyright © 2018年 songguohua. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfigurationTemplate.h"
#import "IndexViewController.h"
#import <UMCommon/UMCommon.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    NSString *realmVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"RLMRealmVersion"];
    if (![realmVersion isEqualToString:kVersionBuild]) {
        NSLog(@"!!!!!RLMRealmVersiong:%zi 与本地版本:%@不匹配,删除Document文件夹",[RLMRealm version],kVersionBuild);
        [self removeDocumentItems];
        [[NSUserDefaults standardUserDefaults] setObject:kVersionBuild forKey:@"RLMRealmVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSInteger launch = [[NSUserDefaults standardUserDefaults] integerForKey:kLaunch];
    launch ++;
    [[NSUserDefaults standardUserDefaults] setInteger:launch forKey:kLaunch];
    
    NSString *channel;
#if DEBUG
    channel = @"Debug";
#else
    channel = @"AppStore";
    [CMAutoTrackerOperation sharedInstance];
#endif
    [UMConfigure initWithAppkey:@"5badcc98b465f55447000177" channel:channel];

    [TBActionSheet appearance].sheetWidth = kScreenW;
    [TBActionSheet appearance].backgroundTransparentEnabled = NO;
    [TBActionSheet appearance].rectCornerRadius = 0;
    [TBActionSheet appearance].buttonFont = UIFontMake(18);
    [TBActionSheet appearance].buttonHeight = 50.0f;
    
    [AppConfigurationTemplate applyConfigurationTemplate];
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-6037095993957840~7664444552"];

    IndexViewController *indexController = [[IndexViewController alloc] init];
    YPNavigationController *indexNav = [[YPNavigationController alloc] initWithRootViewController:indexController];
    self.window.rootViewController = indexNav;
    
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    return YES;
}

- (void)removeDocumentItems {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        BOOL successd = [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        NSLog(@"%@删除%@",successd?@"成功":@"失败",filename);
    }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
