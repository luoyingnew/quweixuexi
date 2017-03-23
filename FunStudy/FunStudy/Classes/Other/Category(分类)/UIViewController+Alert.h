//
//  UIViewController+Alert.h
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertViewBlock) (void);

typedef void (^PickerImageBlock)(UIImage *image);

@interface UIViewController (Alert)





/**
 *  简单的Alert提示框
 *
 *  @param title      标题
 *  @param message    内容
 *  @param cancelTitle 取消按钮的文字
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle;

/**
 *  简单的Alert提示框
 *
 *  @param title      标题
 *  @param message    内容
 *  @param cancelTitle 取消按钮的文字
 *  @param cancelBloack  点击取消干的事
 */

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
               cancelBlock:(AlertViewBlock)cancelBloack;

/**
 *  简单的Alert提示框
 *
 *  @param title      标题
 *  @param message    内容

 *  @param cancleBlock  点击取消触发
 *  @param certainBloack 点击确定触发
 */
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelBlock:(AlertViewBlock)cancleBlock
               certainBlock:(AlertViewBlock)certainBloack;



/**
 简单的Action提示框

 @param title       标题
 @param message     内容
 @param cancelTitle 取消名字
 */
- (void)showActionWithTitle:(NSString *)title
                    message:(NSString *)message
                cancelTitle:(NSString *)cancelTitle;

/**
 简单的Action提示框

 @param title         标题
 @param message       内容
 @param cancleBlock   取消Block
 @param certainBloack 确定Block
 */
- (void)showActionWithTitle:(NSString *)title
                    message:(NSString *)message
                cancelBlock:(AlertViewBlock)cancleBlock
               certainBlock:(AlertViewBlock)certainBloack;

/**
  简单的Action提示框

 @param title        标题
 @param message      内容
 @param cancelTitle  取消名字
 @param cancelBloack 取消Block
 */
- (void)showActionWithTitle:(NSString *)title
                    message:(NSString *)message
                cancelTitle:(NSString *)cancelTitle
                cancelBlock:(AlertViewBlock)cancelBloack;

//展示图片相册
- (void)showActionImagePickerWithPickerImageBlock:(PickerImageBlock)pickerImageBlock;

@end
