//
//  JJNavigationController.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJNavigationController.h"

@interface JJNavigationController ()

@end

@implementation JJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.interactivePopGestureRecognizer.delegate = nil;
    // Do any additional setup after loading the view.
}

/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    DebugLog(@"%s     %ld",__func__,self.viewControllers.count);
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 所有设置搞定后, 再push控制器
    [super pushViewController:viewController animated:animated];
}




@end
