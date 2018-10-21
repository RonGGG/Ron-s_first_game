//
//  ScoreListCellContent.h
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/10/21.
//  Copyright © 2018  Ron. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreListCellContent : NSObject
@property (strong,nonatomic) NSString * avatar_url;
@property (strong,nonatomic) NSString * nickname;
@property (strong,nonatomic) NSString * highestScore;

@end

NS_ASSUME_NONNULL_END
