//
//  GroundView.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/29.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "GroundView.h"
@interface GroundView()
@property (assign,nonatomic) CGFloat move_x;
@end
@implementation GroundView
/*得到一个随机的宽度(>=球的宽度,<屏幕宽度)*/
-(CGFloat)getRadom_ground_wid{
    //随机生成小于SCREEN_WIDTH的数
    return (CGFloat)arc4random_uniform(SCREEN_WIDTH);
}
/*在x出生成一个随机宽度的ground*/
-(instancetype)initWithRandom:(CGFloat)x{
    if (self = [super init]) {
        //属性初始化
        self.frame = CGRectMake(x, SCREEN_HEIGHT-GROUND_HEIGHT, [self getRadom_ground_wid], GROUND_HEIGHT);
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        //手势初始化
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panFunc:)];
        [self addGestureRecognizer:pan];
    }
    //每次生成新的view都要打印所有的views
    NSLog(@"subviews:%@",self.superview.subviews);
    return self;
}
/*init就是x为0的初始化*/
-(instancetype)init{
    return [self initWithRandom:0];
}
-(void)panFunc:(UIPanGestureRecognizer*)sender{
    //查看是否需要生成新的ground
    CGFloat position;
    if ((position = [self ground_check])!=0) {
        //生成新的ground
        self.createNewGround(position);
    }
    //手指坐标
    CGPoint point = [sender locationInView:self.superview];
    //    [sender locationOfTouch:0 inView:self.view];//获取touch数组中某一个index的touch的位置
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"*UIGestureRecognizerStateBegan*");
            self.move_x = point.x-sender.view.center.x;
            NSLog(@"self.movex: %f",self.move_x);
            break;
        }
        case UIGestureRecognizerStateChanged:{
            NSLog(@"*UIGestureRecognizerStateChanged*");
            //通过手势位置，计算出当前view的center
            point = CGPointMake(point.x-self.move_x, self.frame.origin.y+GROUND_HEIGHT/2);
            //得到两点之间位移
            CGFloat move = point.x-sender.view.center.x;
            for (UIView * view in self.superview.subviews) {
                if (view!=self) {
                    CGPoint viewCenter = CGPointMake(view.center.x+move, view.center.y);
                    view.center = viewCenter;
                }
            }
            //更改center
            sender.view.center = point;
            break;
        }
        default:
            break;
    }
    
    
}
/*该方法检查是否需要生成新的ground,需要则返回需要新生成的view的x，否则返回0*/
-(CGFloat)ground_check{
    CGRect lastObj_frame = self.superview.subviews.lastObject.frame;
    if (lastObj_frame.origin.x+lastObj_frame.size.width+GROUND_WID<=SCREEN_WIDTH) {
        return lastObj_frame.origin.x+lastObj_frame.size.width+GROUND_WID;
    }
    return 0;
}
@end
