//
//  TheCardView.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/1.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheCardView : UIView
-(instancetype)initWithScore:(NSString*)score;
-(void)setThemeWithBackgroundColor:(CGFloat)back_Hue andWordColor:(CGFloat)word_Hue;
//block:点击playagain回调
@property void (^block_PlayAgain)(void);
//当前分数
@property (nonatomic,strong) NSString * score_str;
@end
