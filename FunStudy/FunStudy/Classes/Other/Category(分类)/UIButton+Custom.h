//
//  UIButton+Custom.h
//  HiFun
//
//  Created by hao on 16/8/18.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置按钮图片与title
@interface UIButton (Custom)
/**
 *  按钮内的文字和图片垂直居中
 *
 *  @param space 文字和图片间距
 */
- (void)verticalCenterImageAndTitle:(float)space;

/**
 *  按钮内的文字和图片垂直居中
 */
- (void)verticalCenterImageAndTitle;

/**
 *  按钮内的文字和图片水平居中     图左文字右
 *
 *  @param space 文字和图片间距
 */
- (void)horizontalCenterImageAndTitle:(float)space;


/**
 按钮内的文字和图片水平居中     图右文字左

 @param space 图片和文字间距
 */
- (void)horizontalCenterTitleAndImage:(float)space;
@end



//增加可点击区域范围
@interface UIButton (Enlarge)

/**
 *  增加button的可点击范围
 */
- (void) setEnlargeEdgeWithTop:(CGFloat) top
                         right:(CGFloat) right
                        bottom:(CGFloat) bottom
                          left:(CGFloat) left;

@end
