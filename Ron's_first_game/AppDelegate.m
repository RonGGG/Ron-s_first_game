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
//#include "sys/utsname.h"
#import "UserInfo.h"
#import "SignUpView.h"
#import <AFNetworking.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
extern NSString * const firstTimeStartGame;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions");
//    //获取设备信息
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    extern NSString * const machineType;
//    //并数据持久化保存硬盘：
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding] forKey:machineType];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    /*初始化*/
    NSString * isFirstTime = [[NSUserDefaults standardUserDefaults] objectForKey:firstTimeStartGame];
    if (isFirstTime==nil) {//说明第一次使用App
        NSLog(@"Is first time");
        [[NSUserDefaults standardUserDefaults] setObject:@"STARTED" forKey:firstTimeStartGame];
        [UserInfo sharedUser].isFirstTime = YES;   //这个变量专门用于设置第一次主题用
    }else{
        NSLog(@"Not fisrt time");
        //加载用户信息
        [UserInfo readAccount];
        if ([UserInfo sharedUser].uid==nil) {
            [UserInfo sharedUser].isFirstTime = YES;
        }else{
            [UserInfo sharedUser].isFirstTime = NO;
        }
    }
    UserInfo * u = [UserInfo sharedUser];
    NSLog(@"uid:%@ nick:%@ pass:%@ sex:%@ scores:%ld",u.uid,u.nickName,u.password,u.sex,u.highestScore);
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
    if (self.block_applicationWillResignActive) {
        NSLog(@"block_applicationWillResignActive");
        self.block_applicationWillResignActive();
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([UserInfo sharedUser].uid!=nil) {//登陆状态下
        //保存用户信息到磁盘
        [UserInfo saveAccount];
        //网络请求：更新用户信息
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        NSDictionary * dic = @{@"uid":[NSString stringWithFormat:@"%@",[UserInfo sharedUser].uid],@"score":[NSString stringWithFormat:@"%ld",[UserInfo sharedUser].highestScore]};
        [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_DOMAIN,@"/score/save"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"msg: %@",[responseObject objectForKey:@"msg"]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error:%@",error);
        }];
    }
    NSLog(@"To disk:%@的最高分是：%ld",[UserInfo sharedUser].nickName,(long)[UserInfo sharedUser].highestScore);
    NSLog(@"To disk:%f",[UserInfo sharedUser].background_Hue);
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
    NSLog(@"From disk:%f",[UserInfo sharedUser].background_Hue);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if ([UserInfo sharedUser].uid!=nil) {//登陆状态下
        //保存用户信息到磁盘
        [UserInfo saveAccount];
        //网络请求：更新用户信息
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        NSDictionary * dic = @{@"uid":[NSString stringWithFormat:@"%@",[UserInfo sharedUser].uid],@"score":[NSString stringWithFormat:@"%ld",[UserInfo sharedUser].highestScore]};
        [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_DOMAIN,@"/score/save"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"msg: %@",[responseObject objectForKey:@"msg"]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error:%@",error);
        }];
    }
    NSLog(@"Terminate To disk:%@的最高分是：%ld",[UserInfo sharedUser].nickName,(long)[UserInfo sharedUser].highestScore);
    NSLog(@"Terminate To disk:%f",[UserInfo sharedUser].background_Hue);
}


@end
