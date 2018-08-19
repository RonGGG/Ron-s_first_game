//
//  AppDelegate.h
//  Ron's_first_game
//
//  Created by  Ron on 2018/7/25.
//  Copyright © 2018年  Ron. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property void (^block_applicationWillResignActive)(void);
@end

