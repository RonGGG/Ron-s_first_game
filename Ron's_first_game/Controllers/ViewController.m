//
//  ViewController.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/25.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "ViewController.h"
#import "GroundView.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //元祖ground:
    GroundView * ground = [[GroundView alloc]init];
    ground.createNewGround = ^(CGFloat x_of_new) {
        [self createGround:x_of_new];
    };
    [self.view addSubview:ground];
    
    CGFloat positoin;
    if ((positoin = [ground ground_check])!=0) {
        [self createGround:positoin];
    }
    
}
-(void)createGround:(CGFloat)x{
    //递归ground
    GroundView * ground_new = [[GroundView alloc]initWithRandom:x];
    [self.view addSubview:ground_new];
    ground_new.createNewGround = ^(CGFloat x_of_new) {
        [self createGround:x_of_new];
    };
    CGFloat positoin;
    if ((positoin = [ground_new ground_check])!=0) {
        [self createGround:x];
    }
}


@end
