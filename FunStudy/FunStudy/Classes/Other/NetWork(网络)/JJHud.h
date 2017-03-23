//
//  JJHud.h
//  Chocolate
//
//  Created by lwb on 2016/10/13.
//  Copyright © 2016年 北京进击科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHud : NSObject

/**
 显示 Toast形式 的提示信息 显示后自动消失

 @param title 显示的文字
 */
+ (void)showToast:(NSString *)title;


/**
 显示loading的 加载状态

 @param title loading时候的图片
 */
+ (void)showStatus:(NSString *)title;


/**
  隐藏loading 加载框
 */
+ (void)dismiss;


/**
 显示 系统自带的 alert 提示框，仅仅显示而没有用到代理方法的情况下使用的

 @param title       title 文字
 @param message     message 文字
 @param cancelTitle 点击取消显示的 文字
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle;



/**
 显示 系统自带的 alert 提示框，仅仅显示而没有用到代理方法的情况下使用的
 主要为了应对 当前控制器的rootViewController不在keywindow上的情况
 @param title          title 文字
 @param message        message 文字
 @param cancelTitle    点击取消显示的 文字
 @param viewController 需要显示的控制器
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
        fromViewController:(UIViewController *)viewController;
@end
