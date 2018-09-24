//
//  UserInfo.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/5.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
/*用户信息数据：
 {
 uid，
 昵称，
 头像，
 性别，
 最高分数：记录历史最高成绩（获取积分数组时用）
 分数数组：记录每次更新的积分信息
 背景颜色，
 words颜色，
 球颜色
 }
*/
@property (strong,nonatomic) NSNumber * uid;
@property (strong,nonatomic) NSString * nickName;
@property (strong,nonatomic) NSData * avatar;
@property (assign,nonatomic) BOOL isMale;
@property (assign,nonatomic) NSInteger highestScore;

@property (assign,nonatomic) float background_Hue;
@property (assign,nonatomic) float words_Hue;
@property (assign,nonatomic) float ball_Hue;

@property (assign,nonatomic) BOOL isFirstTime;

//返回用户单例：
+(UserInfo *)sharedUser;
//保存用户信息到磁盘
+(void)saveAccount;
//从磁盘读取用户信息
+(void)readAccount;
@end
