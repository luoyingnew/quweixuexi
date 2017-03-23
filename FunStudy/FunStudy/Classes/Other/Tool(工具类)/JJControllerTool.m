//
//  IWControllerTool.m
//  传智WB
//
//  Created by 唐天成 on 15-10-26.
//  Copyright (c) 2015年 唐天成. All rights reserved.
//

#import "JJControllerTool.h"
#import "JJLoginOrSignUpViewController.h"
#import "JJTabBarController.h"
#import "JJNavigationController.h"
@implementation JJControllerTool
+ (void)chooseController{
    
    UIApplication* application=[UIApplication sharedApplication];
    UIWindow* window=[application keyWindow];
    //若用户已经登录
    User *user = [User getUserInformation];
    if (user) {
        user.wait_homework = NO;
        user.new_homework = NO;
        user.new_test = NO;
        [User saveUserInformation:user];
        JJTabbarController *tabBarController=[[JJTabbarController alloc]init];
        window.rootViewController=tabBarController;
    } else {//用户未登录
        JJLoginOrSignUpViewController *loginOrSignUpVC = [[JJLoginOrSignUpViewController alloc]init];
        JJNavigationController *loginOrSignUpViewController = [[JJNavigationController alloc]initWithRootViewController:loginOrSignUpVC];
        loginOrSignUpViewController.navigationBarHidden = YES;
        window.rootViewController = loginOrSignUpViewController;
        
    }
    
}
@end
