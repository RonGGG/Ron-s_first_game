//
//  ChangSkinView.m
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/9/19.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "ChangSkinView.h"

@implementation ChangSkinView

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
        UILabel * background_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH, 40)];
        background_label.textColor = [UIColor whiteColor];
        background_label.text = @"backgrond color";
        background_label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        [self addSubview:background_label];
        UISlider *background_slide = [[UISlider alloc]initWithFrame:CGRectMake(10, 120, SCREEN_WIDTH-20, 30)];
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
        word_slide.tag = 2;
        word_slide.minimumTrackTintColor = [UIColor whiteColor];
        word_slide.maximumTrackTintColor = [UIColor whiteColor];
        word_slide.maximumValue = 360;
        word_slide.minimumValue = 0;
        [word_slide addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:word_slide];
    }
    return self;
}
//slider动作：
-(void)sliderChanged:(UISlider*)slider{
    switch (slider.tag) {
        case 0://background
        {
            self.changeBackgroundColor(slider.value/360.0, 1.0, 1.0,1.0);
            break;
        }
        case 1://ball
        {
            self.changeBallColor(slider.value/360.0, 1.0, 1.0, 1.0);
            break;
        }
        case 2://words
        {
            self.backgroundColor = [UIColor colorWithHue:slider.value/360.0 saturation:1.0 brightness:1.0 alpha:1.0];
            self.changeWordsColor(slider.value/360.0, 1.0, 1.0, 1.0);
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
@end
