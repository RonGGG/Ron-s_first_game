//
//  StartInterfaceController.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/1.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "StartInterfaceController.h"
#import "ViewController.h"
#import "ScoresViewController.h"
#import "UserInfo.h"
#import "UINavigationController+WXSTransition.h"
#import "ChangSkinView.h"
#import "SignUpView.h"
#import "SignInView.h"
#import <AFNetworking.h>
@interface StartInterfaceController ()
/*View*/
@property (weak,nonatomic) ChangSkinView * changeSkinView;
/*属性*/
@property (assign,nonatomic) BOOL changeBeShown;//更换颜色菜单是否出现

@property (assign,nonatomic) CGFloat backgroundColor_Hue;//控制器主题颜色
@property (assign,nonatomic) CGFloat ballColor_Hue;//ball的颜色
@property (assign,nonatomic) CGFloat wordColor_Hue;//Word颜色
@property (weak,nonatomic) UIButton * playNow;
@property (weak,nonatomic) UIButton * checkScores;
@property (weak,nonatomic) UIButton * logOut;
@property (weak,nonatomic) UILabel * welcome_label;
@property (weak,nonatomic) UILabel * username_label;

//@property (assign,nonatomic) CGFloat themeColor_S;
//@property (assign,nonatomic) CGFloat themeColor_B;
//@property (assign,nonatomic) CGFloat themeColor_alpha;


@end

@implementation StartInterfaceController
extern NSString * const firstTimeStartGame;
extern NSString * const storeUserKey;
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置当前view的属性
    self.view.backgroundColor = [UIColor whiteColor];
    self.changeBeShown = NO;
    //设置UI:
    [self setUI];
    if ([UserInfo sharedUser].isFirstTime) {
        [self setSignUpView];
    }else{
        [self checkAccount];
    }
    self.username_label.text = [UserInfo sharedUser].nickName;
//    //先查看本地有没有已存在的用户
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@-uid",storeUserKey]]==nil) {
//        //说明本地不存在用户信息
//        //1.创建登陆界面
//        //注册View:
////        [self setSignUpView];
//        //2.发送create请求
//        //3.用户信息本地保存
//
//    }else{
//        //说明本地存在用户信息
//        //1.发送query请求查看服务器该用户是否存在
//        //2. 存在则：1)比较分数，使用高的 2）同步 网络-本地 信息
//        //   不存在则进入创建用户界面，步骤同上面的if
//    }
    //判断如何更新主题
    if (![UserInfo sharedUser].isFirstTime) {
        self.backgroundColor_Hue = [UserInfo sharedUser].background_Hue;
        self.ballColor_Hue = [UserInfo sharedUser].ball_Hue;
        self.wordColor_Hue = [UserInfo sharedUser].words_Hue;
        NSLog(@"Back and ball and word : %f %f %f ",self.backgroundColor_Hue,self.ballColor_Hue,self.wordColor_Hue);
        if (self.backgroundColor_Hue==0) {
            self.view.backgroundColor = [UIColor whiteColor];
        }else{
            self.view.backgroundColor = [UIColor colorWithHue:[UserInfo sharedUser].background_Hue saturation:0.5 brightness:1.0 alpha:1.0];
        }
        if (self.wordColor_Hue==0) {
            self.welcome_label.textColor = [UIColor blackColor];
            self.username_label.textColor = [UIColor blackColor];
            self.playNow.layer.backgroundColor = [UIColor blackColor].CGColor;
            self.checkScores.layer.backgroundColor = [UIColor blackColor].CGColor;
            self.logOut.layer.backgroundColor = [UIColor blackColor].CGColor;
            self.changeSkinView.backgroundColor = [UIColor blackColor];
        }else{
            self.welcome_label.textColor = [UIColor colorWithHue:[UserInfo sharedUser].words_Hue saturation:0.5 brightness:1.0 alpha:1.0];
            self.username_label.textColor = [UIColor colorWithHue:[UserInfo sharedUser].words_Hue saturation:0.5 brightness:1.0 alpha:1.0];
            self.playNow.layer.backgroundColor = [UIColor colorWithHue:[UserInfo sharedUser].words_Hue saturation:0.5 brightness:1.0 alpha:1.0].CGColor;
            self.checkScores.layer.backgroundColor = [UIColor colorWithHue:[UserInfo sharedUser].words_Hue saturation:0.5 brightness:1.0 alpha:1.0].CGColor;
            self.logOut.layer.backgroundColor = [UIColor colorWithHue:[UserInfo sharedUser].words_Hue saturation:0.5 brightness:1.0 alpha:1.0].CGColor;
            self.changeSkinView.backgroundColor = [UIColor colorWithHue:[UserInfo sharedUser].words_Hue saturation:0.5 brightness:1.0 alpha:1.0];
        }
    }
}
-(void)setSignUpView{
    SignUpView * log = [[SignUpView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2)];
    log.block_resetUI = ^{
        self.username_label.text = [UserInfo sharedUser].nickName;
        [UserInfo saveAccount];
    };
    [self.view addSubview:log];
}
-(void)checkAccount{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSLog(@"UserInfo %@ %@",[UserInfo sharedUser].nickName,[UserInfo sharedUser].password);
    NSDictionary * dic = @{@"nickname":[UserInfo sharedUser].nickName,@"password":[UserInfo sharedUser].password};
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_DOMAIN,@"/user/login"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * responds = responseObject;
        NSLog(@"res %@",responds);
        NSNumber * code = [responds objectForKey:@"code"];
        if ([code integerValue]==100) {
            NSLog(@"不需要手动登陆");
            NSDictionary * data = [responds objectForKey:@"data"];
            NSLog(@"data %@",data);
            NSString * highest_str = [NSString stringWithFormat:@"%@",[data objectForKey:@"highScore"]];
            NSLog(@"highest : %@",highest_str);
            NSInteger highest = [highest_str integerValue];
            //比较分数
            if ([UserInfo sharedUser].highestScore < highest) {

                [UserInfo sharedUser].highestScore = highest;
            }
        }else{
            NSLog(@"Need to login View");
            SignUpView * log = [[SignUpView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2)];
            log.block_resetUI = ^{
                self.username_label.text = [UserInfo sharedUser].nickName;
                [UserInfo saveAccount];
            };
            [self.view addSubview:log];
            SignInView * signIn = [[SignInView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2)];
            signIn.block_resetUI = ^{
                self.username_label.text = [UserInfo sharedUser].nickName;
                [UserInfo saveAccount];
            };
            [log addSubview:signIn];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"checkAccount Error");
    }];
}
-(void)setUI{
    //开始游戏按钮：
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-10)/2, SCREEN_HEIGHT/3*2, SCREEN_WIDTH-150, 70)];
    btn.tag = 0;
    self.playNow = btn;
    [btn setTitle:@"Play Now    >" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
    btn.layer.cornerRadius = 35;
    btn.layer.masksToBounds = YES;
    btn.layer.backgroundColor = [UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //查看记分榜按钮：
    UIButton * checkScores = [[UIButton alloc]initWithFrame:CGRectMake(-30, SCREEN_HEIGHT/2+30, SCREEN_WIDTH-150, 50)];
    checkScores.tag = 1;
    self.checkScores = checkScores;
    [checkScores setTitle:@"<    View scores" forState:UIControlStateNormal];
    checkScores.titleLabel.textColor = [UIColor whiteColor];
    checkScores.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
    checkScores.layer.cornerRadius = 25;
    checkScores.layer.masksToBounds = YES;
    checkScores.layer.backgroundColor = [UIColor blackColor].CGColor;
    [checkScores addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkScores];
    //显示欢迎字体
    UILabel * welcome_label = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/6, SCREEN_WIDTH, 100)];
    self.welcome_label = welcome_label;
    welcome_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:40];
    welcome_label.textAlignment = NSTextAlignmentCenter;
    welcome_label.textColor = [UIColor blackColor];
    welcome_label.text = @"Welcome back!";
    [self.view addSubview:welcome_label];
    //显示用户信息
    UILabel * username_label = [[UILabel alloc]initWithFrame:CGRectMake(0, welcome_label.frame.origin.y+60, SCREEN_WIDTH, 100)];
    self.username_label = username_label;
    username_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
    username_label.textAlignment = NSTextAlignmentCenter;
    username_label.textColor = [UIColor blackColor];
    //    if ([UserInfo sharedUser].isMale) {
    //        username_label.text = [NSString stringWithFormat:@"Mr.%@",[UserInfo sharedUser].nickName];
    //    }else{
    //        username_label.text = [NSString stringWithFormat:@"Ms.%@",[UserInfo sharedUser].nickName];
    //    }
//    username_label.text = [UserInfo sharedUser].nickName;
    [self.view addSubview:username_label];
    //登出按钮：
    UIButton * logOut = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3*2-30, 50, SCREEN_WIDTH/2, 50)];
    logOut.tag = 3;
    self.logOut = logOut;
    logOut.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
    [logOut addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [logOut setTitle:@"Log out   ×" forState:UIControlStateNormal];
    logOut.layer.cornerRadius = 25;
    logOut.layer.masksToBounds = YES;
    logOut.titleLabel.textColor = [UIColor whiteColor];
    logOut.layer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view addSubview:logOut];
    //更换主题按钮L：
    CGFloat wid = SCREEN_WIDTH;
    
    UIButton * changeSkin = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 50)];
    changeSkin.tag = 2;
    [changeSkin setTitle:@"Change skin" forState:UIControlStateNormal];
    changeSkin.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
    [changeSkin addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    ChangSkinView * changeSkin_back = [[ChangSkinView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, wid, SCREEN_HEIGHT)];
    self.changeSkinView = changeSkin_back;
    changeSkin_back.changeBackgroundColor = ^(CGFloat color_h, CGFloat color_s, CGFloat color_b, CGFloat alpha) {
        //更改本控制器中各背景颜色
        if (color_h!=0) {
            self.view.backgroundColor = [UIColor colorWithHue:color_h saturation:color_s brightness:color_b alpha:alpha];
        }else{
            self.view.backgroundColor = [UIColor whiteColor];
        }
        //更改本控制器background颜色
        self.backgroundColor_Hue = color_h;
    };
    changeSkin_back.changeBallColor = ^(CGFloat color_h, CGFloat color_s, CGFloat color_b, CGFloat alpha) {
        self.ballColor_Hue = color_h;
    };
    changeSkin_back.changeWordsColor = ^(CGFloat color_h, CGFloat color_s, CGFloat color_b, CGFloat alpha) {
        if (color_h!=0) {
            welcome_label.textColor = [UIColor colorWithHue:color_h saturation:color_s brightness:color_b alpha:alpha];
            username_label.textColor = [UIColor colorWithHue:color_h saturation:color_s brightness:color_b alpha:alpha];
            btn.backgroundColor = [UIColor colorWithHue:color_h saturation:color_s brightness:color_b alpha:alpha];
            checkScores.backgroundColor = [UIColor colorWithHue:color_h saturation:color_s brightness:color_b alpha:alpha];
            logOut.backgroundColor = [UIColor colorWithHue:color_h saturation:color_s brightness:color_b alpha:alpha];
            self.wordColor_Hue = color_h;
        }else{
            welcome_label.textColor = [UIColor blackColor];
            username_label.textColor = [UIColor blackColor];
            btn.backgroundColor = [UIColor blackColor];
            checkScores.backgroundColor = [UIColor blackColor];
            logOut.backgroundColor = [UIColor blackColor];
            self.wordColor_Hue = 0;
        }
    };
    changeSkin_back.closeChangeView = ^{
        [self closeTheChangeSkinView];
    };
    changeSkin_back.backgroundColor = [UIColor blackColor];
    changeSkin_back.layer.cornerRadius = 18;
    changeSkin_back.layer.masksToBounds = YES;
    
    [changeSkin_back addSubview:changeSkin];
    [self.view addSubview:changeSkin_back];
    
}
-(void)clickBtn:(UIButton*)sender{
    NSLog(@"Tag:%ld",sender.tag);
    switch (sender.tag) {
        case 0:{
            ViewController * VC = [[ViewController alloc]init];
            [VC setBackgroundColorWith:self.backgroundColor_Hue andS:1.0 andB:1.0 andA:1.0];
            [VC setBallColorWith:self.ballColor_Hue andS:1.0 andB:1.0 andA:1.0];
            [VC setGroundColorWith:self.wordColor_Hue andS:1.0 andB:1.0 andA:1.0];
            [self wxs_presentViewController:VC makeTransition:^(WXSTransitionProperty *transition) {
                transition.animationTime = 0.5;
                transition.animationType = WXSTransitionAnimationTypeSysCubeFromRight;
            } completion:^{
                NSLog(@"ViewController Loaded");
            }];
            break;
        }
        case 1:
        {
            ScoresViewController * scoreVC = [[ScoresViewController alloc]init];
            [scoreVC loadSocresFromServer];
            [scoreVC setBackgroundColorWith:self.backgroundColor_Hue andS:1.0 andB:1.0 andA:1.0];
            [scoreVC setWordsColorWith:self.wordColor_Hue andS:1.0 andB:1.0 andA:1.0];
            [self wxs_presentViewController:scoreVC makeTransition:^(WXSTransitionProperty *transition) {
                transition.animationTime = 0.5;
                transition.animationType = WXSTransitionAnimationTypeSysCubeFromLeft;
            } completion:^{
                NSLog(@"ScoresViewController Loaded");
            }];
            break;
        }
        case 2:
        {
            NSLog(@"change skin");
            if (!self.changeBeShown) {
                //更改changeskincview的slider
                [self.changeSkinView setColorValue];

                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    CGPoint center = self.changeSkinView.center;
                    self.changeSkinView.center = CGPointMake(center.x, center.y-SCREEN_HEIGHT*2/3+60);
                    //                self.changeSkinView.frame = CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3);
                } completion:^(BOOL finished) {
                    if (finished) {
                        NSLog(@"Finish!");
                        self.changeBeShown = YES;
                    }
                }];
            }else{
                [self closeTheChangeSkinView];
            }
            break;
        }
        case 3:
        {
            //网络请求：更新用户信息
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            NSDictionary * dic = @{@"uid":[NSString stringWithFormat:@"%@",[UserInfo sharedUser].uid],@"score":[NSString stringWithFormat:@"%ld",[UserInfo sharedUser].highestScore]};
            [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_DOMAIN,@"/score/save"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"msg: %@",[responseObject objectForKey:@"msg"]);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error:%@",error);
            }];
            //设置本地用户信息
            [UserInfo sharedUser].uid = nil;
            [UserInfo sharedUser].isFirstTime = YES;
            //进入SignUp页面
            [self setSignUpView];
            break;
        }
        default:
            break;
    }
    
}
-(void)closeTheChangeSkinView{
    //实现主题数据保存
//    UserInfo * user = [UserInfo sharedUser];
//    user.background_Hue = self.backgroundColor_Hue;
//    user.ball_Hue = self.ballColor_Hue;
//    user.words_Hue = self.wordColor_Hue;
    //close动画实现
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGPoint center = self.changeSkinView.center;
        self.changeSkinView.center = CGPointMake(center.x, center.y+SCREEN_HEIGHT*2/3-60);
        //                self.changeSkinView.frame = CGRectMake(0, SCREEN_HEIGHT*2/3, SCREEN_WIDTH, SCREEN_HEIGHT/3);
    } completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"Finish!");
            self.changeBeShown = NO;
        }
    }];
}

@end
