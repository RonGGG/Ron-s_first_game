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
#import "UserInfo.h"
#import "UINavigationController+WXSTransition.h"

#import "AppDelegate.h"
@interface ViewController ()
/*UI属性*/
@property (weak,nonatomic) UIView * ground_back;//groundView的背景(注意:这个view上子视图只能是groundview，因为他的subviews会动)
@property (weak,nonatomic) BallView * ball;//球视图
@property (weak,nonatomic) UIButton * pause_btn;//暂停按钮
@property (weak,nonatomic) GroundView * firstGround;//元祖grund
@property (weak,nonatomic) UIView * backView;//inset.top为safe area的背景view
//@property (weak,nonatomic) UIView * clearBack;//点击暂停时用来挡住ground，以不能对ground操作
@property (weak,nonatomic) UILabel * points;//显示分数数字
/*数据属性*/
@property (assign,nonatomic) CGFloat totalScores;//当前的已得的分数
@property (assign,nonatomic) CGFloat duration;//球跳跃的时间间隙 初始化为0.5
//@property (assign,nonatomic) CGFloat count;//未使用（为之后增加球的弹跳高度用）
@property (weak,nonatomic) UIPanGestureRecognizer * currentGes;//当前触摸手势

@property (assign,nonatomic) CGFloat lastTouch_groundBack;

@property (assign,nonatomic) CGFloat backgroundColor;//控制器背景颜色
@property (assign,nonatomic) CGFloat ballColor;//BallColor
@property (assign,nonatomic) CGFloat groundColor;//GroundColor
//@property (assign,nonatomic) CGFloat themeColor_S;
//@property (assign,nonatomic) CGFloat themeColor_B;
//@property (assign,nonatomic) CGFloat themeColor_alpha;

//@property (assign,nonatomic) BOOL gesture_lock;//手势锁，1为已上锁，0为未上锁
//@property (strong,nonatomic) NSTimer * timer;

/*引用属性*/
extern NSInteger level;
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
/*计算分数*/
-(void)calculate_scores{
    //计算分数:
    GroundView * currentGround = [self checkCurrentGround];//得到当前球所落的ground
    if (currentGround.hasLanded) {//球如果已经落过，则不再计算分数
        return;
    }
    currentGround.hasLanded = YES;//球已经落过
    /*
     计算当前ground的分数:
     一次函数形式增长，BALL_DIAMETER处是分界，k会有一个突变
     (暂时就用这个方法吧，后期如果需要再改)
     */
    CGFloat scores;
    NSLog(@"***Currentwid:%f",currentGround.frame.size.width);
    CGFloat k1 = -0.5;
    CGFloat b1 = 1-k1*SCREEN_WIDTH/2;
    CGFloat k2 = 50*k1;
    CGFloat b2 = (k1*BALL_DIAMETER+b1)-k2*BALL_DIAMETER;
    if (currentGround.frame.size.width>BALL_DIAMETER) {//正比k增长
        scores = currentGround.frame.size.width*k1 + b1 + 6;
    }else{//正比 10k 增长
        scores = currentGround.frame.size.width*k2 + b2 + 6;
    }
    NSLog(@"***Scores:%f",scores);
    self.totalScores+=scores;//分数累计
    NSLog(@"**Totals:%f",self.totalScores);
    //更新视图:
    self.points.text = [NSString stringWithFormat:@"%ld",(NSInteger)self.totalScores];
}
/*检查当前球在哪个ground上落下:(如果没有返回nil，当然这种情况发生就说明程序出错了)*/
-(GroundView * )checkCurrentGround{
    for (GroundView * view in self.ground_back.subviews) {
        if (view.frame.origin.x<SCREEN_WIDTH/2 && view.frame.origin.x+view.frame.size.width>SCREEN_WIDTH/2) {
            return view;
        }
    }
    return nil;
}
/*检查游戏是否结束*/
-(BOOL)check_gameover{
    //检查球是否掉下去
    if (self.ball.center.y==SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER/2) {//球已到最低点
        for (GroundView * view in self.ground_back.subviews) {
            if (view.frame.origin.x+view.frame.size.width<SCREEN_WIDTH/2 && view.frame.origin.x+view.frame.size.width+view.behind_gap>SCREEN_WIDTH/2) {
//                UIView * test = [[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x+view.frame.size.width, SCREEN_HEIGHT/3*2-100, view.behind_gap, 100)];
//                test.backgroundColor = [UIColor redColor];
//                [self.view addSubview:test];
                NSLog(@"View_x : %f",view.frame.origin.x);
//                NSLog(@"View_front : %f",view.front_gap);
                return YES;
            }
        }
    }
    return NO;
}
/*展示结束界面*/
-(void)showEnd{
    //做底层 view
    UIView * backOfCard = [[UIView alloc]initWithFrame:self.view.frame];
    backOfCard.backgroundColor = [UIColor blackColor];
    backOfCard.layer.opacity = 0.8;
    [self.view addSubview:backOfCard];
    //展示结束界面
    TheCardView * card = [[TheCardView alloc] initWithScore:[NSString stringWithFormat:@"%ld",(NSInteger)self.totalScores]];
    [card setThemeWithBackgroundColor:self.backgroundColor andWordColor:self.groundColor];
    card.block_PlayAgain = ^{
        //移除背景
        [backOfCard removeFromSuperview];
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
-(void)ballAnimationWithDuration:(NSTimeInterval)duration andBounceHeight:(CGFloat)height{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint tempPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER/2-height);
        tempPoint.y += height;
        self.ball.center=tempPoint;
    } completion:^(BOOL finished) {
        if (finished) {
            if (!self.pause_btn.isSelected) {
                [self.ball.layer removeAllAnimations];
                return ;
            }
            if ([self check_gameover]) {//查看球是否游戏结束
                //比较分数
                if (((NSInteger)self.totalScores) > [UserInfo sharedUser].highestScore) {
                    [UserInfo sharedUser].highestScore = self.totalScores;
                }
                //这里做游戏结束处理：
                [self.ball.layer removeAllAnimations];
                //更改按钮状态
                [self.pause_btn setSelected:NO];
                /*展示结束界面*/
                [self showEnd];
                return ;
            }else{//游戏未结束
                //计算分数
                [self calculate_scores];
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGPoint tempPoint = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER/2);
                    tempPoint.y -= (height);
                    self.ball.center=tempPoint;
                } completion:^(BOOL finished) {
                    if (finished) {
                        if (!self.pause_btn.isSelected) {
                            [self.ball.layer removeAllAnimations];
                            return ;
                        }
//                        CGFloat levelFloat = level;
//                        if (level<5) {
//                            self.duration = self.duration-levelFloat/10;
//                        }else{
//                            self.duration = self.duration-0.4;
//                        }
                        [self ballAnimationWithDuration:duration andBounceHeight:height];
//                        NSLog(@"Level&Duration %ld %f",level,self.duration);
                    }
                }];
            }
        }
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //开始游戏
    [self startGameWithDuration:self.duration andBounceHeight:60];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}
//-(void)timer:(id)sender{
//    self.count+=10;
//    NSLog(@"Cunt: %f",self.count);
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置当前控制器的属性
    if (self.backgroundColor!=0) {
        self.view.backgroundColor = [UIColor colorWithHue:self.backgroundColor saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
    //初始化当前控制器各种成员变量
//    self.count = 0;
    self.duration = 0.5;
    AppDelegate * appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appdelegate.block_applicationWillResignActive = ^{
        //比较分数
        if (((NSInteger)self.totalScores) > [UserInfo sharedUser].highestScore) {
            [UserInfo sharedUser].highestScore = self.totalScores;
        }
        [self stopGame];
    };
//    self.gesture_lock = NO;
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
//    self.timer = timer;
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //BackView
    UIView * backView = [[UIView alloc]init];
    self.backView = backView;
    backView.backgroundColor = [UIColor clearColor];
//    backView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:backView];
    //ground的背景
    UIView * ground_background = [[UIView alloc]initWithFrame:self.view.frame];
    self.ground_back = ground_background;
    ground_background.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:ground_background];
    UIPanGestureRecognizer * panOneGroundBack = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnGroundBack:)];
    panOneGroundBack.minimumNumberOfTouches = 1;
    panOneGroundBack.maximumNumberOfTouches = 1;
    [ground_background addGestureRecognizer:panOneGroundBack];
    //创建元祖ground方法
    [self createInitGround];
    //Ball
    BallView * ball = [[BallView alloc]initWithFrame:CGRectMake(self.view.center.x-BALL_DIAMETER/2, SCREEN_HEIGHT-GROUND_HEIGHT-BALL_DIAMETER-60, BALL_DIAMETER, BALL_DIAMETER)];
    self.ball = ball;
    NSLog(@"BallColor:%f",self.ballColor);
    if (self.ballColor!=0) {
        ball.layer.backgroundColor = [UIColor colorWithHue:self.ballColor saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
    }else{
        ball.layer.backgroundColor = [UIColor blackColor].CGColor;
    }
    [self.backView addSubview:ball];
    //Go Back to StartInterface:
    UIButton * goBack = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [goBack setImage:[UIImage imageNamed:@"go_back_left"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBackTo_startInterface) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:goBack];
    //Pause:
    UIButton * pause = [[UIButton alloc]initWithFrame:CGRectMake(goBack.frame.origin.x+goBack.frame.size.width+20, goBack.frame.origin.y, 50, 50)];
    self.pause_btn = pause;
    [pause setSelected:NO];
    [pause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [pause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [pause addTarget:self action:@selector(clickPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:pause];
    //Scores:
    CGFloat suf_wid = 80;
    UILabel * suffix = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-suf_wid-10, 10, suf_wid, 50)];
    suffix.textAlignment = NSTextAlignmentCenter;
    suffix.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:25];
    suffix.textColor = [UIColor blackColor];
    suffix.text = @"points";
    [self.backView addSubview:suffix];
    
    CGFloat pointsWid = SCREEN_WIDTH-(pause.frame.origin.x+pause.frame.size.width+10)-suf_wid-10;
    UILabel * points = [[UILabel alloc]initWithFrame:CGRectMake(pause.frame.origin.x+pause.frame.size.width+10, 10, pointsWid, 50)];
    self.points = points;
    points.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:25];
    points.textAlignment = NSTextAlignmentRight;
    points.textColor = [UIColor blackColor];
    points.text = @"0";
    [self.backView addSubview:points];
    
}
/*创建元祖ground*/
-(void)createInitGround{
    //元祖ground:
    GroundView * ground = [[GroundView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2+BALL_DIAMETER/2, 0)];
    NSLog(@"Behind : %f",ground.behind_gap);
    if (self.groundColor!=0) {
        ground.backgroundColor = [UIColor colorWithHue:self.groundColor saturation:0.5 brightness:0.9 alpha:1.0];
    }else{
        ground.backgroundColor = [UIColor grayColor];
    }
    self.firstGround = ground;
    self.totalScores = 0;  //新一轮游戏需要置零记分器
    ground.hasLanded = NO;
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
    //手势回调block
    ground.block_GestureStateEnd = ^(GroundView *view, CGPoint position, UIPanGestureRecognizer *sender) {
        [self gestureStateEnd:view andPoint:position andGesture:sender];
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
    NSLog(@"subviews count:%ld",self.ground_back.subviews.count);
    
    //递归ground
    GroundView * ground_new = [[GroundView alloc]initWithRandom:x];
    if (self.groundColor!=0) {
        ground_new.backgroundColor = [UIColor colorWithHue:self.groundColor saturation:0.5 brightness:0.9 alpha:1.0];
    }else{
        ground_new.backgroundColor = [UIColor grayColor];
    }
//    //设置ground的属性(将最后一个ground后的gap赋值给新创建的groundnew的frontgap)
//    GroundView * pre = self.ground_back.subviews.lastObject;
//    ground_new.front_gap = pre.behind_gap;
    //检查游戏难度：
    if ([self checkLevel]) {
        [self updateGameLevel];//更新游戏难度
    }
    [self doSomethingWhenCreating:ground_new];
    //得到每次新生成的ground的宽度
//    CGFloat widOfGround = ground_new.frame.size.width;
    //表示球没有在这个ground上落过
    ground_new.hasLanded = NO;
    
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
    //手势回调block
    ground_new.block_GestureStateEnd = ^(GroundView *view, CGPoint position, UIPanGestureRecognizer *sender) {
        [self gestureStateEnd:view andPoint:position andGesture:sender];
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
        [self stopGame];
        //暂停不可以操作ground
        self.ground_back.userInteractionEnabled = NO;
    }else{//show"begin"
        //可以操作ground
        self.ground_back.userInteractionEnabled = YES;
        [self startGameWithDuration:0.5 andBounceHeight:60];
    }
}
/*手势statebegin调用方法*/
-(void)gestureStateBegin:(GroundView *)ground andPoint:(CGPoint)point andGesture:(UIPanGestureRecognizer*)sender{
//    NSLog(@"UIPanGestureRecognizer:%@",sender);
    if (self.currentGes==nil) {
        self.currentGes = sender;
        //第一次触摸view的点和view中心点的x方向的位移
        ground.move_x = point.x-sender.view.center.x;
        NSLog(@"First touch move: %f",ground.move_x);
    }
}
/*手势statechanged回调方法*/
-(void)gestureStateChanged:(GroundView *)ground andPoint:(CGPoint)point andGesture:(UIPanGestureRecognizer*)sender{
//    NSLog(@"UIPanGestureRecognizer:%@",sender);
    if (sender==self.currentGes) {
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
}
/*手势stateEnd回调方法*/
-(void)gestureStateEnd:(GroundView *)ground andPoint:(CGPoint)point andGesture:(UIPanGestureRecognizer*)sender{
    if (sender==self.currentGes) {
        self.currentGes = nil;
    }
}
//开始游戏调用
-(void)startGameWithDuration:(NSTimeInterval)duration andBounceHeight:(CGFloat)height{
    //开始游戏
    [self.pause_btn setSelected:YES];
    self.ground_back.userInteractionEnabled = YES;
    [self ballAnimationWithDuration:duration andBounceHeight:height];
}
//停止游戏调用
-(void)stopGame{
    //停止游戏
    [self.pause_btn setSelected:NO];
    self.ground_back.userInteractionEnabled = NO;
}
//返回Start界面
-(void)goBackTo_startInterface{
    //比较分数
    if (((NSInteger)self.totalScores) > [UserInfo sharedUser].highestScore) {
        [UserInfo sharedUser].highestScore = self.totalScores;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated");
    }];
}
-(void)panOnGroundBack:(UIPanGestureRecognizer * )sender{
    //查看是否需要生成新的ground
    CGFloat position;
    if ((position = [self ground_check])!=0) {
        //生成新的ground
        [self createGround:position];
    }
    //手指坐标
    CGPoint point = [sender locationInView:self.view];
//    NSLog(@"point: (%f,%f)",point.x,point.y);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
//            NSLog(@"*UIGestureRecognizerStateBegan*");
            //第一次触摸view的点和view中心点的x方向的位移
            self.lastTouch_groundBack = point.x;
            break;
        }
        case UIGestureRecognizerStateChanged:{
//            NSLog(@"*UIGestureRecognizerStateChanged*");
            //得到两点之间位移(move>0:右移 move:<0:左移)
            CGFloat move = point.x-self.lastTouch_groundBack;
            self.lastTouch_groundBack = point.x;
            //约束第一个ground的左边界
            CGRect frame = self.firstGround.frame;
            if (frame.origin.x+move<0) {
                //更改所有view的x变量以达到整体移动的效果
                for (GroundView * view in self.ground_back.subviews) {
                    CGPoint viewCenter = CGPointMake(view.center.x+move, view.center.y);
                    view.center = viewCenter;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
            break;
        }
        default:
            break;
    }
}

/*该方法检查是否需要生成新的ground,需要则返回需要新生成的view的x，否则返回0*/
-(CGFloat)ground_check{
    GroundView * last_ground = self.ground_back.subviews.lastObject;
    CGRect lastObj_frame = last_ground.frame;
    if (lastObj_frame.origin.x+lastObj_frame.size.width+last_ground.behind_gap<=SCREEN_WIDTH) {
        return lastObj_frame.origin.x+lastObj_frame.size.width+last_ground.behind_gap;
//        return SCREEN_WIDTH;
    }
    return 0;
}
//检查游戏难度:
-(BOOL)checkLevel{
//    NSLog(@"total&level:%f  %ld",self.totalScores,level);
    if (self.totalScores > 1000*(level+1)) {
        return YES;
    }
    return NO;
}
//更新游戏难度:
-(void)updateGameLevel{
    level+=1;
    NSLog(@"Level:%ld",level);
}
//创建新的ground时调用
-(void)doSomethingWhenCreating:(GroundView *)ground_new{
    
}
//重置image大小：
-(UIImage*) originImage:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * currentImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImg;
}
//设置background颜色
-(void)setBackgroundColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha{
    self.backgroundColor = H;
}
//设置ball颜色的依据变量
-(void)setBallColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha{
    NSLog(@"Ball color is : %f",H);
    self.ballColor = H;
}
//设置ground颜色的依据变量
-(void)setGroundColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha{
    self.groundColor = H;
}
@end
