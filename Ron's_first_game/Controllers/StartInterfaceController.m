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
@interface StartInterfaceController ()
/*View*/
@property (weak,nonatomic) ChangSkinView * changeSkinView;
/*属性*/
@property (assign,nonatomic) BOOL changeBeShown;
@end

@implementation StartInterfaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    //这里先初始化一个假的用户模型
    [UserInfo sharedUser].nickName = @"GZR";
    [UserInfo sharedUser].isMale = YES;
    //设置当前view的属性
    self.view.backgroundColor = [UIColor whiteColor];
    self.changeBeShown = NO;
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
    //更换主题按钮L：
    CGFloat wid = SCREEN_WIDTH;
    ChangSkinView * changeSkin_back = [[ChangSkinView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, wid, SCREEN_HEIGHT)];
    self.changeSkinView = changeSkin_back;
    changeSkin_back.backgroundColor = [UIColor blackColor];
    changeSkin_back.layer.cornerRadius = 18;
    changeSkin_back.layer.masksToBounds = YES;
    UIButton * changeSkin = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wid, 50)];
    changeSkin.tag = 2;
    [changeSkin setTitle:@"Change skin" forState:UIControlStateNormal];
//    changeSkin.backgroundColor = [UIColor blueColor];
//    changeSkin.titleLabel.textColor = [UIColor whiteColor];
    changeSkin.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
//    changeSkin.layer.cornerRadius = 25;
//    changeSkin.layer.masksToBounds = YES;
//    changeSkin.layer.backgroundColor = [UIColor clearColor].CGColor;
    [changeSkin addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [changeSkin_back addSubview:changeSkin];
    [self.view addSubview:changeSkin_back];
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
        case 2:
        {
            NSLog(@"change skin");
            if (!self.changeBeShown) {
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
