//
//  UIStoryboard+JJEasyCreate.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "UIStoryboard+JJEasyCreate.h"

@implementation UIStoryboard (JJEasyCreate)

+ (UIViewController *)instantiateInitialViewControllerWithStoryboardName:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    return viewController;
}

+ (UIViewController *)instantiateViewControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}


@end
