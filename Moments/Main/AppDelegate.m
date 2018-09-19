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
#import "SWStatus.h"
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
    [AppConfigurationTemplate applyConfigurationTemplate];
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-6037095993957840~7664444552"];

    IndexViewController *indexController = [[IndexViewController alloc] init];
    SWNavigationController *indexNav = [[SWNavigationController alloc] initWithRootViewController:indexController];
    self.window.rootViewController = indexNav;
    [self.window makeKeyAndVisible];

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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
