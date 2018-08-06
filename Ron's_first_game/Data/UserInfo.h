//
//  UserInfo.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/5.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (strong,nonatomic) NSString * userName;
@property (assign,nonatomic) NSInteger scores;

+(UserInfo *)sharedUser;
@end
