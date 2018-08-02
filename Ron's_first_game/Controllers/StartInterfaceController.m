//
//  StartInterfaceController.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/1.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "StartInterfaceController.h"
#import "ViewController.h"
@interface StartInterfaceController ()

@end

@implementation StartInterfaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"Type:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"machineType"]);
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT/2-30, 60, 60)];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 30;
    btn.layer.masksToBounds = YES;
    btn.layer.backgroundColor = [UIColor redColor].CGColor;
    [btn addTarget:self action:@selector(clickStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)clickStart:(UIButton*)sender{
    ViewController * vc = [[ViewController alloc]init];
    [self presentViewController:vc animated:NO completion:^{
        NSLog(@"ViewController Loaded");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
