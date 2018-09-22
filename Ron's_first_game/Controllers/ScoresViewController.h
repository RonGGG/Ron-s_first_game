//
//  ScoresViewController.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/6.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "ViewController.h"

@interface ScoresViewController : UIViewController
-(void)loadSocresFromServer;
//设置背景颜色
-(void)setBackgroundColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha;
//设置球颜色
-(void)setWordsColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha;
//属性颜色值
@property (assign,nonatomic) CGFloat viewBackground_Hue;
@property (assign,nonatomic) CGFloat scoresBoard_label_Hue;
@property (assign,nonatomic) CGFloat myHighest_label_Hue;
@property (assign,nonatomic) CGFloat highest_label_Hue;
@property (assign,nonatomic) CGFloat myHighest_Hue;
@property (assign,nonatomic) CGFloat highest_Hue;
@property (assign,nonatomic) CGFloat scoreList_label_Hue;
@end
