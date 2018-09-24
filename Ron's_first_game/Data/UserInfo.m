//
//  UserInfo.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/5.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "UserInfo.h"
extern NSString * const storeUserKey;
static UserInfo * user = nil;
@implementation UserInfo
+ (UserInfo *)sharedUser{
    if (user==nil) {
        user = [[UserInfo alloc]init];
        user.highestScore = 0;
    }
    return user;
}
+(void)saveAccount{
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo sharedUser].uid forKey:[NSString stringWithFormat:@"%@-uid",storeUserKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo sharedUser].nickName forKey:[NSString stringWithFormat:@"%@-nickName",storeUserKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[UserInfo sharedUser].avatar forKey:[NSString stringWithFormat:@"%@-avatar",storeUserKey]];
    //这里把几个assign的类型都转换成了NSNumber
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc]initWithBool:[UserInfo sharedUser].isMale] forKey:[NSString stringWithFormat:@"%@-isMale",storeUserKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc]initWithInteger:[UserInfo sharedUser].highestScore] forKey:[NSString stringWithFormat:@"%@-highestScore",storeUserKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[UserInfo sharedUser].background_Hue] forKey:[NSString stringWithFormat:@"%@-background_Hue",storeUserKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[UserInfo sharedUser].ball_Hue] forKey:[NSString stringWithFormat:@"%@-ball_Hue",storeUserKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[UserInfo sharedUser].words_Hue] forKey:[NSString stringWithFormat:@"%@-words_Hue",storeUserKey]];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc]initWithBool:[UserInfo sharedUser].isFirstTime] forKey:[NSString stringWithFormat:@"%@-isFirstTime",storeUserKey]];
    
    NSLog(@"Save back & ball & words : %f %f %f",[UserInfo sharedUser].background_Hue,[UserInfo sharedUser].ball_Hue,[UserInfo sharedUser].words_Hue);
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)readAccount{
    UserInfo * userFromDisk = [UserInfo sharedUser];
    userFromDisk.uid = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-uid",storeUserKey]];
    userFromDisk.nickName = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-nickName",storeUserKey]];
    userFromDisk.avatar = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-avatar",storeUserKey]];
    NSString * sex = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-isMale",storeUserKey]];
    userFromDisk.isMale = [sex boolValue];
    NSString * score = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-highestScore",storeUserKey]];
    userFromDisk.highestScore = [score integerValue];
    NSString * background_Hue = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-background_Hue",storeUserKey]];
    userFromDisk.background_Hue = [background_Hue floatValue];
    NSString * ball_Hue = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-ball_Hue",storeUserKey]];
    userFromDisk.ball_Hue = [ball_Hue floatValue];
    NSString * words_Hue = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-words_Hue",storeUserKey]];
    userFromDisk.words_Hue = [words_Hue floatValue];
    NSString * firstTime = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-isFirstTime",storeUserKey]];
    userFromDisk.isFirstTime = [firstTime boolValue];
    NSLog(@"From disk color: %@ %@ %@",background_Hue,ball_Hue,words_Hue);
}
@end
