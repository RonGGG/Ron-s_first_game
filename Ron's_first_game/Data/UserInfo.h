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
 }
*/
@property (strong,nonatomic) NSNumber * uid;
@property (strong,nonatomic) NSString * nickName;
@property (strong,nonatomic) NSData * avatar;
@property (assign,nonatomic) BOOL isMale;
@property (assign,nonatomic) NSInteger highestScore;


+(UserInfo *)sharedUser;
@end
