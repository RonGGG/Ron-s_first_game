//
//  ChangSkinView.m
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/9/19.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "ChangSkinView.h"
#import "UserInfo.h"
@interface ChangSkinView ()
@property (weak,nonatomic) UISlider * background_slider;
@property (weak,nonatomic) UISlider * ball_slider;
@property (weak,nonatomic) UISlider * words_slider;
@end
@implementation ChangSkinView
-(void)setColorValue{
    UserInfo * user = [UserInfo sharedUser];
    [UIView animateWithDuration:0.2 animations:^{
        [self.background_slider setValue:user.background_Hue*360 animated:YES];
        [self.ball_slider setValue:user.ball_Hue*360 animated:YES];
        [self.words_slider setValue:user.words_Hue*360 animated:YES];
    }];
    NSLog(@"back value: %f",self.background_slider.value);
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 18;
        self.layer.masksToBounds = YES;
        
        //添加下滑收起动作
        UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipe];
        //Background:
        UILabel * background_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH/2, 40)];
        background_label.textColor = [UIColor whiteColor];
        background_label.text = @"backgrond color";
        background_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        [self addSubview:background_label];
        UISlider *background_slide = [[UISlider alloc]initWithFrame:CGRectMake(10, 120, SCREEN_WIDTH-20, 30)];
        self.background_slider = background_slide;
        background_slide.tag = 0;
        background_slide.minimumTrackTintColor = [UIColor whiteColor];
        background_slide.maximumTrackTintColor = [UIColor whiteColor];
        background_slide.maximumValue = 360;
        background_slide.minimumValue = 0;
        [background_slide addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:background_slide];
        
        //Ball
        UILabel * ball_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, SCREEN_WIDTH, 40)];
        ball_label.textColor = [UIColor whiteColor];
        ball_label.text = @"ball color";
        ball_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        [self addSubview:ball_label];
        UISlider * ball_slide = [[UISlider alloc]initWithFrame:CGRectMake(10, 200, SCREEN_WIDTH-20, 30)];
        self.ball_slider = ball_slide;
        ball_slide.tag = 1;
        ball_slide.minimumTrackTintColor = [UIColor whiteColor];
        ball_slide.maximumTrackTintColor = [UIColor whiteColor];
        ball_slide.maximumValue = 360;
        ball_slide.minimumValue = 0;
        [ball_slide addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:ball_slide];
        
        //Word
        UILabel * word_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, SCREEN_WIDTH, 40)];
        word_label.textColor = [UIColor whiteColor];
        word_label.text = @"words color";
        word_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        [self addSubview:word_label];
        UISlider * word_slide = [[UISlider alloc]initWithFrame:CGRectMake(10, 280, SCREEN_WIDTH-20, 30)];
        self.words_slider = word_slide;
        word_slide.tag = 2;
        word_slide.minimumTrackTintColor = [UIColor whiteColor];
        word_slide.maximumTrackTintColor = [UIColor whiteColor];
        word_slide.maximumValue = 360;
        word_slide.minimumValue = 0;
        [word_slide addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:word_slide];
        
        //Return to original theme
        UIButton * return_btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+25, 75, SCREEN_WIDTH/2-50, 30)];
        return_btn.layer.cornerRadius = 12;
        return_btn.layer.masksToBounds = YES;
        return_btn.layer.borderColor = [UIColor whiteColor].CGColor;
        return_btn.layer.borderWidth = 1.0;
        [return_btn setTitle:@"original color" forState:UIControlStateNormal];
        [return_btn addTarget:self action:@selector(returnToOriginal:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:return_btn];
    }
    return self;
}
//slider动作：
-(void)sliderChanged:(UISlider*)slider{
    UserInfo * user = [UserInfo sharedUser];
    switch (slider.tag) {
        case 0://background
        {
            self.changeBackgroundColor(slider.value/360.0, 0.5, 1.0,1.0);
            user.background_Hue = slider.value/360.0;
            break;
        }
        case 1://ball
        {
            self.changeBallColor(slider.value/360.0, 0.5, 1.0, 1.0);
            user.ball_Hue = slider.value/360.0;
            break;
        }
        case 2://words
        {
            self.backgroundColor = [UIColor colorWithHue:slider.value/360.0 saturation:0.5 brightness:1.0 alpha:1.0];
            self.changeWordsColor(slider.value/360.0, 0.5, 1.0, 1.0);
            user.words_Hue = slider.value/360.0;
            break;
        }
        default:
            break;
    }
}
//下滑动作：
-(void)swipeDown:(UISwipeGestureRecognizer*)swipe{
    self.closeChangeView();
}
//点击original按钮
-(void)returnToOriginal:(UIButton*)button{
    [UIView animateWithDuration:0.2 animations:^{
        //颜色恢复
        self.changeBackgroundColor(0.0, 1.0, 1.0,1.0);
        self.changeBallColor(0.0, 1.0, 1.0, 1.0);
        self.changeWordsColor(0.0, 1.0, 1.0, 1.0);
        self.backgroundColor = [UIColor blackColor];
        self.superview.backgroundColor = [UIColor whiteColor];
        //slider恢复
        [self.background_slider setValue:0.0 animated:YES];
        [self.ball_slider setValue:0.0 animated:YES];
        [self.words_slider setValue:0.0 animated:YES];
    }];
    //用户数据恢复
    UserInfo * user = [UserInfo sharedUser];
    user.background_Hue = 0;
    user.ball_Hue = 0;
    user.words_Hue = 0;
    
}
@end
