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
@end

@implementation ViewController
//-(BOOL)check_gameover{
//    if (self.ball.center.x) {
//        <#statements#>
//    }
//}
-(void)ballAnimationWithDuration:(NSTimeInterval)duratoin{
    [UIView animateWithDuration:duratoin delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint tempPoint=self.ball.center;
        tempPoint.y += 60;
        self.ball.center=tempPoint;
    } completion:^(BOOL finished) {
        //check here//
        [UIView animateWithDuration:duratoin delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGPoint tempPoint=self.ball.center;
            tempPoint.y -= 60;
            self.ball.center=tempPoint;
        } completion:^(BOOL finished) {
            [self ballAnimationWithDuration:duratoin];
        }];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //ground的背景
    UIView * ground_background = [[UIView alloc]initWithFrame:self.view.frame];
    self.ground_back = ground_background;
    ground_background.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ground_background];
    
    //元祖ground:
    GroundView * ground = [[GroundView alloc]init];
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
    [self ballAnimationWithDuration:1.0];
}
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


@end
