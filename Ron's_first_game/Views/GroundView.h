//
//  GroundView.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/29.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroundView : UIView
/*该方法用于初始化view，参数x是view的x*/
-(instancetype)initWithRandom:(CGFloat)x;
/*该方法检查是否需要生成新的ground,需要则返回需要新生成的view的x，否则返回0*/
-(CGFloat)ground_check;

/*block:生成新的view(参数:view的x)，controller的回调*/
@property void (^createNewGround)(CGFloat x_of_new);
//@property void (^addSubview)(GroundView * view);
@end
