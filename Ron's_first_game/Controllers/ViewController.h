//
//  ViewController.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/25.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//设置背景颜色
-(void)setBackgroundColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha;
//设置球颜色
-(void)setBallColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha;
//设置ground颜色
-(void)setGroundColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha;
@end

