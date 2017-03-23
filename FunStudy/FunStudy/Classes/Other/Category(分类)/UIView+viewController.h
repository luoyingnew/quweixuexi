//
//  UIView+viewController.h
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (viewController)

/**
 *  寻找View所在的当前控制器
 *
 *  @return UIViewController
 */
- (UIViewController *)viewController;


//获得当前窗口的控制器
+ (UIViewController *)currentViewController;
@end
