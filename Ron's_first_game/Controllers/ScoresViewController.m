//
//  ScoresViewController.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/6.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "ScoresViewController.h"
#import "UserInfo.h"
#import <AFNetworking.h>
@interface ScoresViewController ()
@property (weak,nonatomic) UIView * backView;
/*数据*/
@property (strong,nonatomic) NSMutableArray * scoreList;
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
    //设置当前view属性
    if (self.viewBackground_Hue!=0) {
        self.view.backgroundColor = [UIColor colorWithHue:self.viewBackground_Hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
    //设置backView
    //BackView
    UIView * backView = [[UIView alloc]init];
    self.backView = backView;
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    //Go Back to StartInterface:
    UIButton * goBack = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-50, 10, 50, 50)];
    [goBack setImage:[UIImage imageNamed:@"go_back_right"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(goBackTo_startInterface) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:goBack];
    //Scoreboard label
    UILabel * scoresBoard_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-70, 50)];
    scoresBoard_label.text = @"Scoreboard";
    scoresBoard_label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:40];
    scoresBoard_label.textAlignment = NSTextAlignmentLeft;
    if (self.scoresBoard_label_Hue!=0) {
        scoresBoard_label.textColor = [UIColor colorWithHue:self.scoresBoard_label_Hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        scoresBoard_label.textColor = [UIColor blackColor];
    }
    [self.backView addSubview:scoresBoard_label];
    //我的最高分label
    CGFloat scoresBoard_label_yMax = scoresBoard_label.frame.origin.y+scoresBoard_label.frame.size.height;
    UILabel * myHighest_label = [[UILabel alloc]initWithFrame:CGRectMake(10, scoresBoard_label_yMax+20, SCREEN_WIDTH/2, 40)];
    if (self.myHighest_label_Hue!=0) {
        myHighest_label.textColor = [UIColor colorWithHue:self.myHighest_label_Hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        myHighest_label.textColor = [UIColor blackColor];
    }
    myHighest_label.text = @"Your highest";
    myHighest_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:25];
    myHighest_label.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:myHighest_label];
    //所有用户最高分label
    UILabel * highest_label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, scoresBoard_label_yMax+20, SCREEN_WIDTH/2, 40)];
    if (self.highest_label_Hue!=0) {
        highest_label.textColor = [UIColor colorWithHue:self.highest_label_Hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        highest_label.textColor = [UIColor blackColor];
    }
    highest_label.text = @"Highest";
    highest_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:25];
    highest_label.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:highest_label];
    //我的最高分
    CGFloat myHighest_label_yMax = myHighest_label.frame.origin.y+myHighest_label.frame.size.height;
    UILabel * myHighest = [[UILabel alloc]initWithFrame:CGRectMake(10, myHighest_label_yMax, SCREEN_WIDTH/2, 40)];
    if (self.myHighest_Hue!=0) {
        myHighest.textColor = [UIColor colorWithHue:self.myHighest_Hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        myHighest.textColor = [UIColor blackColor];
    }
    myHighest.text = [NSString stringWithFormat:@"%ld",[UserInfo sharedUser].highestScore];
    myHighest.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:25];
    myHighest.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:myHighest];
    //所有最高分
    UILabel * highest = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, myHighest_label_yMax, SCREEN_WIDTH/2, 40)];
    if (self.highest_Hue!=0) {
        highest.textColor = [UIColor colorWithHue:self.highest_Hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        highest.textColor = [UIColor blackColor];
    }
    highest.text = @"0";
    highest.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:25];
    highest.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:highest];
    //Scorelist label
    CGFloat myHighest_yMax = myHighest.frame.origin.y+myHighest.frame.size.height;
    UILabel * scoreList_label = [[UILabel alloc]initWithFrame:CGRectMake(10, myHighest_yMax+30, SCREEN_WIDTH-20, 50)];
    if (self.scoreList_label_Hue!=0) {
        scoreList_label.textColor = [UIColor colorWithHue:self.scoreList_label_Hue saturation:0.5 brightness:1.0 alpha:1.0];
    }else{
        scoreList_label.textColor = [UIColor blackColor];
    }
    scoreList_label.text = @"Scorelist";
    scoreList_label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:40];
    scoreList_label.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:scoreList_label];
    //显示分数list
    
}
//返回Start界面
-(void)goBackTo_startInterface{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated");
    }];
}
-(void)loadSocresFromServer{
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    NSString * url_string = [NSString stringWithFormat:@"%@%@",MAIN_DOMAIN,@"/user/query/users"];
//    [manager GET:url_string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success--%@--%@",[responseObject class],responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"failure--%@",error);
//
//    }];
}
//设置背景颜色
-(void)setBackgroundColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha{
    self.viewBackground_Hue = H;
}
//设置球颜色
-(void)setWordsColorWith:(CGFloat)H andS:(CGFloat)S andB:(CGFloat)B andA:(CGFloat)alpha{
    self.scoresBoard_label_Hue = H;
    self.myHighest_label_Hue = H;
    self.highest_label_Hue = H;
    self.myHighest_Hue = H;
    self.highest_Hue = H;
    self.scoreList_label_Hue = H;
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
