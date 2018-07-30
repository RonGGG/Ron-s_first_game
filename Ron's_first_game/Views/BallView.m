//
//  BallView.m
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/30.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import "BallView.h"

@implementation BallView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
