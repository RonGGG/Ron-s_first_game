//
//  UserInfo.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/5.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "UserInfo.h"
static UserInfo * user = nil;
@implementation UserInfo
+ (UserInfo *)sharedUser{
    if (user==nil) {
        user = [[UserInfo alloc]init];
        user.highestScore = 0;
    }
    return user;
}
@end
