//
//  SignInView.h
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/9/28.
//  Copyright © 2018  Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignInView : UIView <UITextFieldDelegate>
//更新startviewUI
@property void (^block_resetUI)(void);
@end

NS_ASSUME_NONNULL_END
