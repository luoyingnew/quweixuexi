//
//  JJBaseViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class JJBaseNavigationBar;

@interface JJBaseViewController : UIViewController

@property (nonatomic, strong) UIView * navigationViewBg;
@property (nonatomic, strong) UILabel * navigationTitle;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) UIButton * navigationLeft;
@property (nonatomic, strong) UIButton * navigationRight;


/**左边按钮事件*/
-(void)leftBarButtonClick;

///**左边按钮隐藏状态默认NO*/
//-(void)leftBarButtonHidden:(BOOL)isbool;
//
/////**左边按钮图片设置*/
//-(void)leftBarButtonItemImage:(UIImage *)image leftBool:(BOOL)left;
//
///**右边按钮文字设置*/
//-(void)rightBarButtonItemTitle:(NSString *)title;

/**右边按钮事件*/
-(void)rightBarButtonClick;

///**右边按钮隐藏状态默认YES*/
//
//-(void)rightBarButtonHidden:(BOOL)isbool;
//
///**右边按钮图片设置*/
//-(void)rightBarButtonItemImage:(UIImage *)image;


@end
