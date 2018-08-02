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
#import "TheCardView.h"
@interface ViewController ()
@property (weak,nonatomic) UIView * ground_back;
@property (weak,nonatomic) BallView * ball;

//@property (assign,nonatomic) BOOL pause;
@property (weak,nonatomic) UIButton * pause_btn;
@property (weak,nonatomic) GroundView * firstGround;
@property (weak,nonatomic) UIView * backView;
@property (weak,nonatomic) UIView * clearBack;

@property (assign,nonatomic) CGFloat count;
@property (strong,nonatomic) NSTimer * timer;

@end
//safe area适配：
static inline UIEdgeInsets sgm_safeAreaInset(UIView *view) {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

@implementation ViewController
/*safe area适配*/
- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets inset = sgm_safeAreaInset(self.view);
    inset = UIEdgeInsetsMake(inset.top, inset.left, 0, inset.right);
    self.backView.frame = UIEdgeInsetsInsetRect(self.view.frame, inset);
    NSLog(@"Inset:(%f,%f,%f,%f)",inset.top,inset.left,inset.bottom,inset.right);
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
/*展示结束界面*/
-(void)showEnd{
    //展示结束界面
    TheCardView * card = [[TheCardView alloc]init];
    card.block_PlayAgain = ^{
        //从groundBack中清空所有子视图
        for (GroundView * each_ground in self.ground_back.subviews) {
            [each_ground removeFromSuperview];
        }
        //重新初始化元祖ground
        [self createInitGround];
        //开始游戏
        [self startGameWithDuration:0.5 andBounceHeight:60];
    };
    [self.view addSubview:card];
}
/*球动画方法*/
-(void)ballAnimationWithDuration:(NSTimeInterval)duratoin andBounceHeight:(CGFloat)height{
    [UIView animateWithDuration:duratoin delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        CGPoint tempPoint=self.ball.center;
        CGPoint tempPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER/2-height);
        tempPoint.y += height+self.count;
        self.ball.center=tempPoint;
    } completion:^(BOOL finished) {
        if (finished) {
            if ([self check_gameover]) {
                //这里做游戏结束处理：
                [self.ball.layer removeAllAnimations];
                //更改按钮状态
                [self.pause_btn setSelected:NO];
                /*展示结束界面*/
                [self showEnd];
                return ;
            }else{
                [UIView animateWithDuration:duratoin delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                    CGPoint tempPoint=self.ball.center;
                    CGPoint tempPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER/2);
                    tempPoint.y -= (height+self.count);
                    self.ball.center=tempPoint;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self ballAnimationWithDuration:duratoin andBounceHeight:height];
                    }
                }];
            }
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始游戏
    [self startGameWithDuration:0.5+self.count/100 andBounceHeight:60];
}
-(void)timer:(id)sender{
    self.count+=10;
    NSLog(@"Cunt: %f",self.count);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置当前控制器的属性
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化当前控制器各种成员变量
    self.count = 0;
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
//    self.timer = timer;
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    self.pause = NO;
    //BackView
    UIView * backView = [[UIView alloc]init];
    self.backView = backView;
    backView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:backView];
    //ground的背景
    UIView * ground_background = [[UIView alloc]initWithFrame:self.view.frame];
    self.ground_back = ground_background;
    ground_background.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:ground_background];
    //创建元祖ground方法
    [self createInitGround];
    //Ball
    BallView * ball = [[BallView alloc]initWithFrame:CGRectMake(self.view.center.x-BALL_DIAMETER/2, SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER-60, BALL_DIAMETER, BALL_DIAMETER)];
    self.ball = ball;
    [self.backView addSubview:ball];
    //Pause:
    UIButton * pause = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 50)];
    self.pause_btn = pause;
    [pause setSelected:NO];
    pause.backgroundColor = [UIColor redColor];
    pause.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:20];
    pause.titleLabel.textColor =  [UIColor blackColor];
    
    [pause setTitle:@"Begin" forState:UIControlStateNormal];
    [pause setTitle:@"End" forState:UIControlStateSelected];
    [pause addTarget:self action:@selector(clickPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:pause];
    //Go Back to StartInterface:
    UIButton * goBack = [[UIButton alloc]initWithFrame:CGRectMake(pause.frame.origin.x+pause.frame.size.width+20, pause.frame.origin.y, 50, 50)];
    goBack.backgroundColor = [UIColor redColor];
    [goBack setTitle:@"Back" forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBackTo_startInterface) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:goBack];
}
/*创建元祖ground*/
-(void)createInitGround{
    //元祖ground:
    GroundView * ground = [[GroundView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2+BALL_DIAMETER/2, 0)];
    self.firstGround = ground;
    //    ground.isTheFirstGround = YES;//只有元祖ground才是yes
    ground.createNewGround = ^(CGFloat x_of_new) {
        [self createGround:x_of_new];
    };
    //手势回调block
    ground.block_GestureStateBegin = ^(GroundView *view, CGPoint position, UIPanGestureRecognizer *sender) {
        [self gestureStateBegin:view andPoint:position andGesture:sender];
    };
    //手势回调block
    ground.block_GestureStateChanged = ^(GroundView *view, CGPoint position, UIPanGestureRecognizer *sender) {
        [self gestureStateChanged:view andPoint:position andGesture:sender];
    };
    [self.ground_back addSubview:ground];
    
    CGFloat positoin;
    if ((positoin = [ground ground_check])!=0) {
        [self createGround:positoin];
    }
}
/*创建新的ground*/
-(void)createGround:(CGFloat)x{
    //每次生成新的view都要打印所有的views
    NSLog(@"subviews:%@ count:%ld",self.ground_back.subviews,self.ground_back.subviews.count);
    //递归ground
    GroundView * ground_new = [[GroundView alloc]initWithRandom:x];
//    ground_new.isTheFirstGround = NO;
    [self.ground_back addSubview:ground_new];
    ground_new.createNewGround = ^(CGFloat x_of_new) {
        [self createGround:x_of_new];
    };
    //手势回调block
    ground_new.block_GestureStateBegin = ^(GroundView *view, CGPoint position, UIPanGestureRecognizer *sender) {
        [self gestureStateBegin:view andPoint:position andGesture:sender];
    };
    //手势回调block
    ground_new.block_GestureStateChanged = ^(GroundView *view, CGPoint position, UIPanGestureRecognizer *sender) {
        [self gestureStateChanged:view andPoint:position andGesture:sender];
    };
    CGFloat positoin;
    if ((positoin = [ground_new ground_check])!=0) {
        [self createGround:x];
    }
}
/*点击pause*/
-(void)clickPause:(id)sender{
    UIButton * btn = (UIButton*)sender;
    if (btn.isSelected) {//show"pause"
//        self.pause = YES;
        [self stopGame];
        UIView * clearBack = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-GROUND_HEIGHT, SCREEN_WIDTH, GROUND_HEIGHT)];
        self.clearBack = clearBack;
        clearBack.backgroundColor = [UIColor clearColor];
        [self.view addSubview:clearBack];
    }else{//show"begin"
//        self.pause = NO;
        if (self.clearBack) {
            [self.clearBack removeFromSuperview];
        }
        [self startGameWithDuration:0.5 andBounceHeight:60];
    }
}
/*手势statebegin调用方法*/
-(void)gestureStateBegin:(GroundView *)ground andPoint:(CGPoint)point andGesture:(UIPanGestureRecognizer*)sender{
    //第一次触摸view的点和view中心点的x方向的位移
    ground.move_x = point.x-sender.view.center.x;
    NSLog(@"First touch move: %f",ground.move_x);
}
/*手势statechanged回调方法*/
-(void)gestureStateChanged:(GroundView *)ground andPoint:(CGPoint)point andGesture:(UIPanGestureRecognizer*)sender{
    //通过手势位置，计算出当前view的center
    point = CGPointMake(point.x-ground.move_x, ground.frame.origin.y+GROUND_HEIGHT/2);
    //得到两点之间位移(move>0:右移 move:<0:左移)
    CGFloat move = point.x-sender.view.center.x;
    //约束第一个ground的左边界
    CGRect frame = self.firstGround.frame;
    if (frame.origin.x+move<0) {
        //更改所有view的x变量以达到整体移动的效果
        for (GroundView * view in ground.superview.subviews) {
            if (view!=ground) {
                CGPoint viewCenter = CGPointMake(view.center.x+move, view.center.y);
                view.center = viewCenter;
            }
        }
        //更改center
        sender.view.center = point;
    }
}
//开始游戏调用
-(void)startGameWithDuration:(NSTimeInterval)duration andBounceHeight:(CGFloat)height{
    //开始游戏
    [self.pause_btn setSelected:YES];
    [self ballAnimationWithDuration:duration andBounceHeight:height];
}
//停止游戏调用
-(void)stopGame{
    //停止游戏
    [self.pause_btn setSelected:NO];
    [self.ball.layer removeAllAnimations];
}
//返回Start界面
-(void)goBackTo_startInterface{
    
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"dismissViewControllerAnimated");
    }];
}
@end
