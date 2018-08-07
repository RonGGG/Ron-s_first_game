//
//  ScoresViewController.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/6.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "ScoresViewController.h"

@interface ScoresViewController ()
@property (weak,nonatomic) UIView * backView;
@end
//safe area适配：
static inline UIEdgeInsets sgm_safeAreaInset(UIView *view) {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}
@implementation ScoresViewController
/*safe area适配*/
- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets inset = sgm_safeAreaInset(self.view);
    inset = UIEdgeInsetsMake(inset.top, inset.left, 0, inset.right);
    self.backView.frame = UIEdgeInsetsInsetRect(self.view.frame, inset);
    NSLog(@"Inset:(%f,%f,%f,%f)",inset.top,inset.left,inset.bottom,inset.right);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置当前view属性：
    self.view.backgroundColor = [UIColor whiteColor];
    //设置backView
    //BackView
    UIView * backView = [[UIView alloc]init];
    self.backView = backView;
    backView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:backView];
    //Go Back to StartInterface:
    UIButton * goBack = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-50, 10, 50, 50)];
    [goBack setImage:[UIImage imageNamed:@"go_back_right"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBackTo_startInterface) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:goBack];
    //显示...
    //显示分数
}
//返回Start界面
-(void)goBackTo_startInterface{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated");
    }];
}
//重置image大小：
-(UIImage*) originImage:(UIImage*)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * currentImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImg;
}

@end
