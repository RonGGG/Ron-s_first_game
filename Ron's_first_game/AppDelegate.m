//
//  AppDelegate.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/25.
//  Copyright © 2018年  Ron. All rights reserved.
//


/*
 这里规定AppDelegate
 1）只允许import：
 初始界面的controller
 全局单例对象
 
 2）不允许import：
 除初始界面的controller外的其他controller
 所有和view有关的class
 */
#import "AppDelegate.h"
#import "StartInterfaceController.h"
#include "sys/utsname.h"
#import "UserInfo.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions");
//    //获取设备信息
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    extern NSString * const machineType;
//    //并数据持久化保存硬盘：
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding] forKey:machineType];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    //设置视图:
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    StartInterfaceController * startVC = [[StartInterfaceController alloc]init];
    self.window.rootViewController = startVC;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    self.block_applicationWillResignActive();
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //保存用户信息到磁盘
    [UserInfo saveAccount];
    NSLog(@"To disk:%@的最高分是：%ld",[UserInfo sharedUser].nickName,(long)[UserInfo sharedUser].highestScore);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //从磁盘读取用户信息到单例中
    [UserInfo readAccount];
    NSLog(@"From disk:%@的最高分是：%ld",[UserInfo sharedUser].nickName,(long)[UserInfo sharedUser].highestScore);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //保存用户信息到磁盘
    [UserInfo saveAccount];
    NSLog(@"To disk:%@的最高分是：%ld",[UserInfo sharedUser].nickName,(long)[UserInfo sharedUser].highestScore);
}


@end
