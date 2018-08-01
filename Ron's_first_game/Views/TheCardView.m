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
@end
@implementation TheCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.frame = CGRectMake((SCREEN_WIDTH-CARD_WIDTH)/2, (SCREEN_HEIGHT-CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT);
        
        self.backgroundColor = [UIColor grayColor];
        
        UIButton * playAgain = [[UIButton alloc]init];
        self.playAgain = playAgain;
        playAgain.backgroundColor = [UIColor redColor];
        [playAgain setTitle:@"PlayAgain" forState:UIControlStateNormal];
        playAgain.titleLabel.textColor = [UIColor whiteColor];
        
        [playAgain addTarget:self action:@selector(playAgain:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playAgain];
    }
    return self;
}
-(void)playAgain:(UIButton*)sender{
    self.block_PlayAgain();
    [self removeFromSuperview];
}
- (void)layoutSubviews{
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    self.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
    self.playAgain.frame = CGRectMake(0, 0, 0, 0);
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake((SCREEN_WIDTH-CARD_WIDTH)/2, (SCREEN_HEIGHT-CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT);
        self.playAgain.frame = CGRectMake(CARD_WIDTH/2-50, CARD_HEIGHT/2-50, 100, 100);
        self.playAgain.layer.cornerRadius = self.playAgain.frame.size.height/2;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
@end
