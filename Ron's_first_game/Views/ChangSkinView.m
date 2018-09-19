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
    }
    return self;
}

@end
