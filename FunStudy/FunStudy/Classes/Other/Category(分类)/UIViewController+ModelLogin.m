//
//  UIViewController+ModelLogin.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "UIViewController+ModelLogin.h"
//#import "JJLoginViewController.h"
#import "JJNavigationController.h"
@implementation UIViewController (ModelLogin)

- (void)modelToLoginVC {
  //  JJLoginViewController *loginViewController = [[JJLoginViewController alloc]init];
   // JJNavigationController *loginNavigationViewController = [[JJNavigationController alloc]initWithRootViewController:loginViewController];
   // [self presentViewController:loginNavigationViewController animated:YES completion:nil];
}

- (BOOL)isPushWayAppear{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            return YES;
        }
    }
        //present方式
        return NO;
}

@end
