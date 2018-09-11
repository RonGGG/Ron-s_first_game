//
//  TheCardView.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/1.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "TheCardView.h"
#import "UserInfo.h"
/*定义card的宽、高分别是屏幕宽高的2/3*/
#define CARD_WIDTH [UIScreen mainScreen].bounds.size.width*3/4
#define CARD_HEIGHT [UIScreen mainScreen].bounds.size.width*3/2
@interface TheCardView()
@property (weak,nonatomic) UIButton * playAgain;
@property (weak,nonatomic) UIView * card;
@property (assign,nonatomic) BOOL show;


@property (weak,nonatomic) UILabel * score;
@property (weak,nonatomic) UILabel * score_prefix;
@property (weak,nonatomic) UILabel * score_highest;
@end
@implementation TheCardView
//-(UILabel *)score{
//    if (!_score) {
//        UILabel * score = [[UILabel alloc]init];
//        _score = score;
////        score.backgroundColor = [UIColor redColor];
//        score.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:25];
//        score.textAlignment = NSTextAlignmentCenter;
//        score.textColor = [UIColor blackColor];
//        [self.card addSubview:score];
//    }
//    return _score;
//}
-(instancetype)initWithScore:(NSString*)score{
    TheCardView * tmp = [self init];
    tmp.score.text = score;
    return tmp;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.frame = CGRectMake((SCREEN_WIDTH-CARD_WIDTH)/2, (SCREEN_HEIGHT-CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT);
        //
        self.show = NO;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        //Card
        UIView * card = [[UIView alloc]init];
        card.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        self.card = card;
        [self addSubview:card];
        //You got
        UILabel * prefix = [[UILabel alloc]init];
        self.score_prefix = prefix;
        prefix.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:60];
        prefix.textAlignment = NSTextAlignmentCenter;
        prefix.textColor = [UIColor blackColor];
        prefix.frame = CGRectMake(0, CARD_HEIGHT/8, CARD_WIDTH, 80);
        prefix.layer.opacity = 0.0;
        prefix.text = @"You got:";
        [self.card addSubview:prefix];
        //Scores
        UILabel * score = [[UILabel alloc]init];
        self.score = score;
        score.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:40];
        score.textAlignment = NSTextAlignmentCenter;
        score.textColor = [UIColor blackColor];
        score.frame = CGRectMake(0, prefix.center.y+60, CARD_WIDTH, 50);
        score.layer.opacity = 0.0;
        [self.card addSubview:score];
        //Highest points:
        UILabel * highestScore = [[UILabel alloc]init];
        self.score_highest = highestScore;
        highestScore.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:25];
        highestScore.textAlignment = NSTextAlignmentCenter;
        highestScore.textColor = [UIColor blackColor];
        highestScore.frame = CGRectMake(0, score.center.y+60, CARD_WIDTH, 50);
        highestScore.layer.opacity = 0.0;
        highestScore.text = [NSString stringWithFormat:@"Highest:%ld",[UserInfo sharedUser].highestScore];
        [self.card addSubview:highestScore];
        //Button
        UIButton * playAgain = [[UIButton alloc]init];
        self.playAgain = playAgain;
        playAgain.backgroundColor = [UIColor blackColor];
        [playAgain setTitle:@"Play again" forState:UIControlStateNormal];
        playAgain.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        playAgain.titleLabel.textAlignment = NSTextAlignmentCenter;
        playAgain.titleLabel.textColor = [UIColor whiteColor];
        [playAgain addTarget:self action:@selector(playAgain:) forControlEvents:UIControlEventTouchUpInside];
        [self.card addSubview:playAgain];
    }
    return self;
}
-(void)playAgain:(UIButton*)sender{
    if (self.show) {
        self.block_PlayAgain();
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.card.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
            //        self.layer.frame = CGRectMake((SCREEN_WIDTH-CARD_WIDTH)/2, (SCREEN_HEIGHT-CARD_HEIGHT)/2, CARD_WIDTH/2, CARD_HEIGHT/2);
            self.playAgain.frame = CGRectMake(0, 0, 0, 0);
            self.score.frame = CGRectMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                self.show = NO;
                [self removeFromSuperview];
            }
        }];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.show == NO) {
        self.card.layer.cornerRadius = 12;
        self.card.layer.masksToBounds = YES;
        self.card.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
        self.playAgain.frame = CGRectMake(0, 0, 0, 0);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.card.frame = CGRectMake((SCREEN_WIDTH-CARD_WIDTH)/2, (SCREEN_HEIGHT-CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT);
            self.playAgain.frame = CGRectMake(CARD_WIDTH/2-CARD_WIDTH/3, CARD_HEIGHT/5*4, CARD_WIDTH*2/3, 60);
            self.playAgain.layer.cornerRadius = self.playAgain.frame.size.height/2;
            
        } completion:^(BOOL finished) {
            if (finished) {
                //透明度变化出现的动画
                [UIView animateWithDuration:0.5 animations:^{
                    self.score.layer.opacity = 1.0;
                    self.score_prefix.layer.opacity =1.0;
                    self.score_highest.layer.opacity = 1.0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        self.show = finished;
                    }
                }];
            }
        }];
    }
    
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
@end
