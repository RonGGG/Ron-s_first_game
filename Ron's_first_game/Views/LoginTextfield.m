//
//  LoginTextfield.m
//  Ron's_first_game
//
//  Created by 郭梓榕 on 2018/9/27.
//  Copyright © 2018  Ron. All rights reserved.
//

#import "LoginTextfield.h"

@implementation LoginTextfield

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置占位符的内容和颜色
        
        self.textAlignment = NSTextAlignmentCenter;
        [self setValue:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1/1.0] forKeyPath:@"_placeholderLabel.textColor"];
//        [self setValue:[UIFont boldSystemFontOfSize:100] forKeyPath:@"_placeholderLabel.font"];
        //下面的线的设置：
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, SCREEN_WIDTH/375*1)];
        lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1/1.0];
        [self addSubview:lineView];
        
        self.tintColor = [UIColor lightGrayColor];
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor blackColor];
        self.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:20];
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
