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
@interface StartInterfaceController ()

@end

@implementation StartInterfaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    //这里先初始化一个假的用户模型
    [UserInfo sharedUser].nickName = @"GZR";
    [UserInfo sharedUser].isMale = YES;
    //设置当前view的属性
    self.view.backgroundColor = [UIColor whiteColor];
    //开始游戏按钮：
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-10)/2, SCREEN_HEIGHT/4*3, SCREEN_WIDTH-150, 70)];
    btn.tag = 0;
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
    welcome_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:40];
    welcome_label.textAlignment = NSTextAlignmentCenter;
    welcome_label.textColor = [UIColor blackColor];
    welcome_label.text = @"Welcome back!";
    [self.view addSubview:welcome_label];
    //显示用户信息
    UILabel * username_label = [[UILabel alloc]initWithFrame:CGRectMake(0, welcome_label.frame.origin.y+60, SCREEN_WIDTH, 100)];
    username_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
    username_label.textAlignment = NSTextAlignmentCenter;
    username_label.textColor = [UIColor blackColor];
//    if ([UserInfo sharedUser].isMale) {
//        username_label.text = [NSString stringWithFormat:@"Mr.%@",[UserInfo sharedUser].nickName];
//    }else{
//        username_label.text = [NSString stringWithFormat:@"Ms.%@",[UserInfo sharedUser].nickName];
//    }
    username_label.text = [UserInfo sharedUser].nickName;
    [self.view addSubview:username_label];
}
-(void)clickBtn:(UIButton*)sender{
    NSLog(@"Tag:%ld",sender.tag);
    switch (sender.tag) {
        case 0:{
            ViewController * VC = [[ViewController alloc]init];
            [self wxs_presentViewController:VC makeTransition:^(WXSTransitionProperty *transition) {
                transition.animationTime = 0.5;
                transition.animationType = WXSTransitionAnimationTypeSysCubeFromRight;
            } completion:^{
                NSLog(@"ViewController Loaded");
            }];
            
//            [self presentViewController:VC animated:NO completion:^{
//                NSLog(@"ViewController Loaded");
//            }];
            break;
        }
        case 1:
        {
            ScoresViewController * scoreVC = [[ScoresViewController alloc]init];
            [self wxs_presentViewController:scoreVC makeTransition:^(WXSTransitionProperty *transition) {
                transition.animationTime = 0.5;
                transition.animationType = WXSTransitionAnimationTypeSysCubeFromLeft;
            } completion:^{
                NSLog(@"ScoresViewController Loaded");
            }];
//            [self presentViewController:scoreVC animated:NO completion:^{
//                NSLog(@"ScoresViewController Loaded");
//            }];
            break;
        }
        default:
            break;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
