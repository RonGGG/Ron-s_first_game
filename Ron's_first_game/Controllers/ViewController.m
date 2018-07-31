//
//  ViewController.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/25.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "ViewController.h"
#import "BallView.h"
#import "GroundView.h"

@interface ViewController ()
@property (weak,nonatomic) UIView * ground_back;
@property (weak,nonatomic) BallView * ball;

@property (assign,nonatomic) BOOL pause;
//@property (weak,nonatomic) UIButton * pause_btn;
@end

@implementation ViewController
/*检查游戏是否暂停*/
-(void)check_pause{
    
}
/*检查游戏是否结束*/
-(BOOL)check_gameover{
    //检查球是否掉下去
    if (self.ball.center.y==SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER/2) {//球已到最低点
        for (GroundView * view in self.ground_back.subviews) {
            if (view.frame.origin.x-GROUND_GAP<SCREEN_WIDTH/2 && view.frame.origin.x>SCREEN_WIDTH/2) {
                return YES;
            }
        }
    }
    return NO;
}
/*球动画方法*/
-(void)ballAnimationWithDuration:(NSTimeInterval)duratoin andBounceHeight:(CGFloat)height{
    [UIView animateWithDuration:duratoin delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint tempPoint=self.ball.center;
        tempPoint.y += height;
        self.ball.center=tempPoint;
    } completion:^(BOOL finished) {
        //check here//
        if ([self check_gameover]) {
            //这里做游戏结束处理：
            [self.ball.layer removeAllAnimations];
            return ;
        }else{
            [UIView animateWithDuration:duratoin delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGPoint tempPoint=self.ball.center;
                tempPoint.y -= height;
                self.ball.center=tempPoint;
            } completion:^(BOOL finished) {
                if (self.pause) {
                    [self.ball.layer removeAllAnimations];
                    return ;
                }
                [self ballAnimationWithDuration:duratoin andBounceHeight:height];
            }];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化各种属性
    self.pause = NO;
    //ground的背景
    UIView * ground_background = [[UIView alloc]initWithFrame:self.view.frame];
    self.ground_back = ground_background;
    ground_background.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ground_background];
    
    //元祖ground:
    GroundView * ground = [[GroundView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2+BALL_DIAMETER/2, 0)];
    ground.createNewGround = ^(CGFloat x_of_new) {
        [self createGround:x_of_new];
    };
    [self.ground_back addSubview:ground];
    
    CGFloat positoin;
    if ((positoin = [ground ground_check])!=0) {
        [self createGround:positoin];
    }
    //Ball
    BallView * ball = [[BallView alloc]initWithFrame:CGRectMake(self.view.center.x-BALL_DIAMETER/2, SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER-60, BALL_DIAMETER, BALL_DIAMETER)];
    self.ball = ball;
    [self.view addSubview:ball];
    //球的动画：
//    [self ballAnimationWithDuration:0.5 andBounceHeight:60];
    //Pause:
    UIButton * pause = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 200, 100)];
//    self.pause_btn = pause;
    [pause setSelected:NO];
    pause.backgroundColor = [UIColor redColor];
    pause.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    pause.titleLabel.textColor =  [UIColor blackColor];
    
    [pause setTitle:@"Begin" forState:UIControlStateNormal];
    [pause setTitle:@"End" forState:UIControlStateSelected];
    [pause addTarget:self action:@selector(clickPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pause];
}
/*创建新的ground*/
-(void)createGround:(CGFloat)x{
    //每次生成新的view都要打印所有的views
    NSLog(@"subviews:%@ count:%ld",self.ground_back.subviews,self.ground_back.subviews.count);
    //递归ground
    GroundView * ground_new = [[GroundView alloc]initWithRandom:x];
    [self.ground_back addSubview:ground_new];
    ground_new.createNewGround = ^(CGFloat x_of_new) {
        [self createGround:x_of_new];
    };
    CGFloat positoin;
    if ((positoin = [ground_new ground_check])!=0) {
        [self createGround:x];
    }
}
/*点击pause*/
-(void)clickPause:(id)sender{
    UIButton * btn = (UIButton*)sender;
    [self.ball.layer removeAllAnimations];
    if (btn.isSelected) {//show"pause"
        self.pause = YES;
        [btn setSelected:NO];
    }else{//show"begin"
        self.pause = NO;
        [btn setSelected:YES];
        
        [self ballAnimationWithDuration:0.5 andBounceHeight:60];
    }
}

@end
