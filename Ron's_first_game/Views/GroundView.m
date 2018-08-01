//
//  GroundView.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/29.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "GroundView.h"
@interface GroundView()

@end
@implementation GroundView
/*得到一个随机的宽度(>=球的宽度,<屏幕宽度)*/
-(CGFloat)getRadom_ground_wid{
    //随机生成小于SCREEN_WIDTH的数
    while (1) {
        if (arc4random_uniform(SCREEN_WIDTH)>=BALL_DIAMETER) {
            return (CGFloat)arc4random_uniform(SCREEN_WIDTH);
        }
    }
}
/*自定义带frame的初始化：(只能自定义x和宽度)*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //属性初始化
        self.frame = CGRectMake(frame.origin.x, SCREEN_HEIGHT-GROUND_HEIGHT, frame.size.width, GROUND_HEIGHT);
        self.backgroundColor = [UIColor darkGrayColor];
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        //手势初始化
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panFunc:)];
        [self addGestureRecognizer:pan];
    }
    
    return self;
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
            //回调block
            self.block_GestureStateBegin(self,point,sender);
            break;
        }
        case UIGestureRecognizerStateChanged:{
//            NSLog(@"*UIGestureRecognizerStateChanged*");
            //回调block
            self.block_GestureStateChanged(self,point,sender);
            break;
        }
        default:
            break;
    }
}
/*该方法检查是否需要生成新的ground,需要则返回需要新生成的view的x，否则返回0*/
-(CGFloat)ground_check{
    CGRect lastObj_frame = self.superview.subviews.lastObject.frame;
    if (lastObj_frame.origin.x+lastObj_frame.size.width+GROUND_GAP<=SCREEN_WIDTH) {
        return lastObj_frame.origin.x+lastObj_frame.size.width+GROUND_GAP;
    }
    return 0;
}
@end
