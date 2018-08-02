//
//  TheCardView.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/8/1.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "TheCardView.h"

/*定义card的宽、高分别是屏幕宽高的2/3*/
#define CARD_WIDTH [UIScreen mainScreen].bounds.size.width*2/3
#define CARD_HEIGHT [UIScreen mainScreen].bounds.size.height*2/3
@interface TheCardView()
@property (weak,nonatomic) UIButton * playAgain;
@property (weak,nonatomic) UIView * card;
@property (assign,nonatomic) BOOL show;
@end
@implementation TheCardView

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
        card.backgroundColor = [UIColor grayColor];
        self.card = card;
        [self addSubview:card];
        //Button
        UIButton * playAgain = [[UIButton alloc]init];
        self.playAgain = playAgain;
        playAgain.backgroundColor = [UIColor redColor];
        [playAgain setTitle:@"PlayAgain" forState:UIControlStateNormal];
        playAgain.titleLabel.textColor = [UIColor whiteColor];
        
        [playAgain addTarget:self action:@selector(playAgain:) forControlEvents:UIControlEventTouchUpInside];
        [self.card addSubview:playAgain];
    }
    return self;
}
-(void)playAgain:(UIButton*)sender{
    self.block_PlayAgain();
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.card.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
        //        self.layer.frame = CGRectMake((SCREEN_WIDTH-CARD_WIDTH)/2, (SCREEN_HEIGHT-CARD_HEIGHT)/2, CARD_WIDTH/2, CARD_HEIGHT/2);
        self.playAgain.frame = CGRectMake(0, 0, 0, 0);
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.show = NO;
            [self removeFromSuperview];
        }
    }];

    
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
            //        self.layer.frame = CGRectMake((SCREEN_WIDTH-CARD_WIDTH)/2, (SCREEN_HEIGHT-CARD_HEIGHT)/2, CARD_WIDTH/2, CARD_HEIGHT/2);
            self.playAgain.frame = CGRectMake(CARD_WIDTH/2-50, CARD_HEIGHT/2-50, 100, 100);
            self.playAgain.layer.cornerRadius = self.playAgain.frame.size.height/2;
        } completion:^(BOOL finished) {
            if (finished) {
                self.show = finished;
            }
        }];
    }
    
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
@end
