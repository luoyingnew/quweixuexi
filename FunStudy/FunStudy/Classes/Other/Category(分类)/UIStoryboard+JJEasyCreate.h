//
//  UIStoryboard+JJEasyCreate.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/6.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (JJEasyCreate)
+ (UIViewController *)instantiateInitialViewControllerWithStoryboardName:(NSString *)storyboardName;
+ (UIViewController *)instantiateViewControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier;
@end
