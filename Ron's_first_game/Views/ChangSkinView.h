//
//  ChangSkinView.h
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/9/19.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangSkinView : UIView
//更改颜色block
@property void (^changeBackgroundColor)(CGFloat color_h,CGFloat color_s,CGFloat color_b,CGFloat alpha);
@property void (^changeBallColor)(CGFloat color_h,CGFloat color_s,CGFloat color_b,CGFloat alpha);
@property void (^changeWordsColor)(CGFloat color_h,CGFloat color_s,CGFloat color_b,CGFloat alpha);
//下滑收起
@property void (^closeChangeView)(void);
@end

NS_ASSUME_NONNULL_END
