//
//  LoginView.m
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/9/27.
//  Copyright © 2018  Ron. All rights reserved.
//

#import "SignUpView.h"
#import "LoginTextfield.h"
#import <AFNetworking.h>
#import "UserInfo.h"
#import "SignInView.h"
@interface SignUpView()
@property (weak,nonatomic) LoginTextfield * nickName_textField;
@property (weak,nonatomic) LoginTextfield * password_textField;
@property (weak,nonatomic) LoginTextfield * passwordVerify_textfield;
@property (strong,nonatomic) NSString * nickName_string;
@property (strong,nonatomic) NSString * password_string;
@property (strong,nonatomic) NSString * passwordVerify_string;
@property (strong,nonatomic) NSString * sex;
@property (weak,nonatomic) LoginTextfield * current_textfield;

@property (weak,nonatomic) UIButton * maleBtn;
@property (weak,nonatomic) UIButton * femaleBtn;

@end
@implementation SignUpView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置属性
        self.backgroundColor = [UIColor whiteColor];
        //增加一个tap背景的手势(方便resignFirstResponser)：
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
        [self addGestureRecognizer:tap];
        
        CGFloat nickName_y = SCREEN_HEIGHT/3+100;
        CGFloat nickName_x = 20;
        CGFloat label_wid = 100;
        CGFloat label_height = 30;
        //Login label:
        UILabel * login_label = [[UILabel alloc]initWithFrame:CGRectMake(nickName_x, SCREEN_HEIGHT/3, SCREEN_WIDTH-nickName_x*2, 50)];
        login_label.text = @"Sign up first!";
        login_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:30];
        login_label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:login_label];
        //昵称
        UILabel * nickName_label = [[UILabel alloc]initWithFrame:CGRectMake(nickName_x, nickName_y, label_wid, label_height)];
        nickName_label.text = @"Nick name: ";
        nickName_label.textColor = [UIColor blackColor];
        nickName_label.textAlignment = NSTextAlignmentRight;
        [self addSubview:nickName_label];
        LoginTextfield * nickName = [[LoginTextfield alloc]initWithFrame:CGRectMake(nickName_x+label_wid+10, nickName_y, SCREEN_WIDTH-nickName_x*2-label_wid-10, label_height)];
        self.nickName_textField = nickName;
        nickName.returnKeyType =UIReturnKeyDone;
        nickName.delegate = self;
        [self addSubview:nickName];
        //性别
        UILabel * sex_label = [[UILabel alloc]initWithFrame:CGRectMake(nickName_x, nickName_y+50, label_wid, label_height)];
        sex_label.text = @"Sex: ";
        sex_label.textColor = [UIColor blackColor];
        sex_label.textAlignment = NSTextAlignmentRight;
        [self addSubview:sex_label];
        UIButton * male = [[UIButton alloc]initWithFrame:CGRectMake(nickName_x+label_wid+10, nickName_y+50, 80, 30)];
        self.maleBtn = male;
        male.tag = 0;
        male.layer.cornerRadius = 15;
        male.layer.masksToBounds = YES;
        male.layer.borderColor = [UIColor blackColor].CGColor;
        male.layer.borderWidth = 1;
        male.layer.backgroundColor = [UIColor whiteColor].CGColor;
        male.selected = NO;
        [male setTitle:@"male" forState:UIControlStateNormal];
        [male setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [male setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [male addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:male];
        UIButton * female = [[UIButton alloc]initWithFrame:CGRectMake(nickName_x+label_wid+100, nickName_y+50, 80, 30)];
        self.femaleBtn = female;
        female.tag = 1;
        female.layer.cornerRadius = 15;
        female.layer.masksToBounds = YES;
        female.layer.borderColor = [UIColor blackColor].CGColor;
        female.layer.borderWidth = 1;
        female.layer.backgroundColor = [UIColor whiteColor].CGColor;
        female.selected = NO;
        [female setTitle:@"female" forState:UIControlStateNormal];
        [female setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [female setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [female addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:female];
        //密码
        UILabel * password_label = [[UILabel alloc]initWithFrame:CGRectMake(nickName_x, nickName_y+100, label_wid, label_height)];
        password_label.text = @"Password: ";
        password_label.textColor = [UIColor blackColor];
        password_label.textAlignment = NSTextAlignmentRight;
        [self addSubview:password_label];
        LoginTextfield * password = [[LoginTextfield alloc]initWithFrame:CGRectMake(nickName_x+label_wid+10, nickName_y+100, SCREEN_WIDTH-nickName_x*2-label_wid-10, label_height)];
        self.password_textField = password;
        password.secureTextEntry = YES;
        password.returnKeyType =UIReturnKeyDone;
        password.delegate = self;
        [self addSubview:password];
        //验证密码
        UILabel * passwordVerify_label = [[UILabel alloc]initWithFrame:CGRectMake(nickName_x, nickName_y+150, label_wid, label_height)];
        passwordVerify_label.text = @"Again: ";
        passwordVerify_label.textColor = [UIColor blackColor];
        passwordVerify_label.textAlignment = NSTextAlignmentRight;
        [self addSubview:passwordVerify_label];
        LoginTextfield * passwordAgain = [[LoginTextfield alloc]initWithFrame:CGRectMake(nickName_x+label_wid+10, nickName_y+150, SCREEN_WIDTH-nickName_x*2-label_wid-10, label_height)];
        self.passwordVerify_textfield = passwordAgain;
        passwordAgain.secureTextEntry = YES;
        passwordAgain.returnKeyType =UIReturnKeyDone;
        passwordAgain.delegate = self;
        [self addSubview:passwordAgain];
        //创建账户按钮
        UIButton * createAccount  = [[UIButton alloc]initWithFrame:CGRectMake(nickName_x, nickName_y+225, SCREEN_WIDTH-40, 40)];
        createAccount.tag = 0;
        [createAccount setTitle:@"Sign up" forState:UIControlStateNormal];
        createAccount.layer.cornerRadius = 5;
        createAccount.layer.backgroundColor = [UIColor blackColor].CGColor;
        [createAccount addTarget:self action:@selector(clickSignUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:createAccount];
        //登陆按钮：
        UIButton * login  = [[UIButton alloc]initWithFrame:CGRectMake(nickName_x, nickName_y+225+50, SCREEN_WIDTH-40, 40)];
        login.tag = 1;
        [login setTitle:@"Sign in" forState:UIControlStateNormal];
        login.layer.cornerRadius = 5;
        login.layer.backgroundColor = [UIColor blackColor].CGColor;
        [login addTarget:self action:@selector(clickSignUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:login];

    }
    return self;
}
//选择性别
-(void)chooseSex:(UIButton*)btn{
    if (btn.tag == 0) {//male
        self.sex = @"male";
        if (btn.selected) {
            self.maleBtn.selected = YES;
            self.maleBtn.layer.backgroundColor = [UIColor blackColor].CGColor;
            self.femaleBtn.selected = NO;
            self.femaleBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        }else{
            self.maleBtn.selected = YES;
            self.maleBtn.layer.backgroundColor = [UIColor blackColor].CGColor;
            self.femaleBtn.selected = NO;
            self.femaleBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        }
    }else{//female
        self.sex = @"female";
        if (btn.selected) {
            self.femaleBtn.selected = YES;
            self.femaleBtn.layer.backgroundColor = [UIColor blackColor].CGColor;
            self.maleBtn.selected = NO;
            self.maleBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        }else{
            self.femaleBtn.selected = YES;
            self.femaleBtn.layer.backgroundColor = [UIColor blackColor].CGColor;
            self.maleBtn.selected = NO;
            self.maleBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        }
    }
}
//点击登录
-(void)clickSignUp:(UIButton *)btn{
    [self.current_textfield resignFirstResponder];
    if (btn.tag==0) {
        //视图调回
        if (self.center.y!=SCREEN_HEIGHT) {
            [UIView animateWithDuration:0.2 animations:^{
                self.center = CGPointMake(self.center.x, SCREEN_HEIGHT);
            }];
        }
        if (!self.nickName_string){
            [self showAlert:@"Input nickname"];
        }else if (!self.password_string) {
            [self showAlert:@"Input password"];
        }else if (!self.passwordVerify_string){
            [self showAlert:@"Input password verify"];
        }else if([self.nickName_string isEqualToString:@""]){
            [self showAlert:@"Input nickname"];
        }else if ([self.password_string isEqualToString:@""]){
            [self showAlert:@"Input password"];
        }else if ([self.passwordVerify_string isEqualToString:@""]){
            [self showAlert:@"Input password verify"];
        }else if (!self.maleBtn.selected && !self.femaleBtn.selected){
            [self showAlert:@"Select sex"];
        }else{
            //对比两次输入密码是否相同
            if ([self.password_string isEqualToString:self.passwordVerify_string]) {
                NSLog(@"Successfully!");
                //检查该用户明是否重复
                AFHTTPSessionManager *pre_manager = [AFHTTPSessionManager manager];
                [pre_manager GET:[NSString stringWithFormat:@"%@/user/uid/0",MAIN_DOMAIN] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary * res = responseObject;
                    NSNumber * pre_code = [res objectForKey:@"code"];
                    if (pre_code.integerValue==100) {//用户存在
                        NSLog(@"用户名已存在，不能创建");
                        [self showAlert:@"用户名已存在，不能创建"];
                    }else{
                        [self creatUser];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                
            }else{
                [self showAlert:@"Inconsistent password"];
            }
        }
    }else{
        SignInView * signIn = [[SignInView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2)];
        signIn.block_resetUI = ^{
            self.block_resetUI();
        };
        [self.superview addSubview:signIn];
        [self removeFromSuperview];
    }
}
//
-(void)creatUser{
    //请求创建用户：
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary * dic = @{@"nickname":self.nickName_string,@"password":self.password_string,@"sex":self.sex};
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_DOMAIN,@"/user/edit"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * responds = responseObject;
        NSNumber * code = [responds objectForKey:@"code"];
        
        if (code.integerValue==100) {
            NSLog(@"code = 100");
            NSLog(@"创建成功!");
            NSDictionary * data = [responds objectForKey:@"data"];
            NSNumber * uid = [data objectForKey:@"uid"];
            NSString * pass = [data objectForKey:@"password"];
            NSString * highest = [data objectForKey:@"highScore"];
            //设置本地用户信息:
            UserInfo * user = [UserInfo sharedUser];
            user.uid = [NSString stringWithFormat:@"%@",uid];
            user.nickName = [NSString stringWithFormat:@"%@",self.nickName_string];
            user.sex = [NSString stringWithFormat:@"%@",self.sex];
            user.password = [NSString stringWithFormat:@"%@",pass];
            user.highestScore = [[NSString stringWithFormat:@"%@",highest] integerValue];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.center = CGPointMake(self.center.x, self.center.y+SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                if (finished) {
                    self.block_resetUI();
                    [self removeFromSuperview];
                }
            }];
        }else{
            NSLog(@"code = 200");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Connection Failed");
    }];
}
//textfield输入结束调用
-(void)tapBack:(UITapGestureRecognizer*)tap{
    NSLog(@"Tap");
    //视图调回
    if (self.center.y!=SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(self.center.x, SCREEN_HEIGHT);
        }];
    }
    //保存输入结果
//    [self saveTextfield];
    //响应者
    if (self.nickName_textField.isFirstResponder) {
        [self.nickName_textField resignFirstResponder];
    }else if (self.password_textField.isFirstResponder){
        [self.password_textField resignFirstResponder];
    }else if (self.passwordVerify_textfield.isFirstResponder){
        [self.passwordVerify_textfield resignFirstResponder];
    }else{
        
    }
}
//textfield输入结束调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"Return");
    //视图调回
    if (self.center.y!=SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(self.center.x, SCREEN_HEIGHT);
        }];
    }
    //保存输入结果
//    [self saveTextfield];
    //响应者
    [textField resignFirstResponder];
    return YES;
}
//textfield开始输入时调用
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.current_textfield = textField;
    NSLog(@"center and 1/2 : %f  %f",textField.center.y,SCREEN_HEIGHT/2);
    CGFloat offset = self.superview.frame.origin.y-self.frame.origin.y;
    CGFloat y = textField.center.y-offset;
    if (y>SCREEN_HEIGHT/2) {
        CGFloat distance = y-SCREEN_HEIGHT/2;
        [UIView animateWithDuration:0.2 animations:^{
            self.center=CGPointMake(self.center.x, self.center.y-distance);
        }];
    }
}
////保存输入数据
-(void)saveTextfield:(UITextField*)textfield{
    if (textfield==self.nickName_textField) {
        self.nickName_string = self.nickName_textField.text;
    }else if(textfield==self.password_textField){
        self.password_string = self.password_textField.text;
    }else if(textfield==self.passwordVerify_textfield){
        self.passwordVerify_string = self.passwordVerify_textfield.text;
    }
}
//
-(void)showAlert:(NSString*)alert_str{
    //显示的提示
    UILabel * alert = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-50, SCREEN_WIDTH-100, 30)];
    alert.layer.cornerRadius = 5;
    alert.layer.masksToBounds = YES;
    alert.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    alert.textColor = [UIColor whiteColor];
    alert.textAlignment = NSTextAlignmentCenter;
    alert.text = alert_str;
    [self addSubview:alert];
    //1.5秒后alert消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert removeFromSuperview];
    });
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"End");
    [self saveTextfield:textField];
}
@end
