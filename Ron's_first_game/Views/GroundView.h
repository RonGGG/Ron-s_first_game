//
//  GroundView.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/29.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroundView : UIView
/*用来标示球是否在这个gronud上落过*/
@property (assign,nonatomic) BOOL hasLanded;
/*第一次触摸点和中心点之间的x方向的位移*/
@property (assign,nonatomic) CGFloat move_x;
/*该方法用于初始化view，参数x是view的x*/
-(instancetype)initWithRandom:(CGFloat)x;
/*该方法检查是否需要生成新的ground,需要则返回需要新生成的view的x，否则返回0*/
-(CGFloat)ground_check;

/*block:生成新的view(参数:view的x)，controller的回调*/
@property void (^createNewGround)(CGFloat x_of_new);
/*block:ground滚动回调*/
@property void (^block_GestureStateChanged)(GroundView * view,CGPoint position,UIPanGestureRecognizer* sender);
@property void (^block_GestureStateBegin)(GroundView * view,CGPoint position,UIPanGestureRecognizer * sender);
@property void (^block_GestureStateEnd)(GroundView * view,CGPoint position,UIPanGestureRecognizer * sender);
@end
