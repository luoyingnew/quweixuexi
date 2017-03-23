//
//  UILabel+labelStyle.h
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelStyle)

/**
 *  一次性设置label所有属性
 *
 *  @param backgroungColor label  背景颜色
 *  @param font            label  字体大小
 *  @param text            label  文字
 *  @param textColor       label  文字颜色
 *  @param textAlignment   label  文字对齐方式
 */
- (void)jj_setLableStyleWithBackgroundColor:(UIColor *)backgroungColor
                                       font:(UIFont *)font
                                       text:(NSString *)text
                                  textColor:(UIColor *)textColor
                              textAlignment:(NSTextAlignment)textAlignment;

/**
 *  做label高度、宽度自适应
 *
 *  @param text label 内容
 *  @param font label 字体
 *
 *  @return label size
 */
+ (CGSize)jj_sizeToFitWithText:(NSString *)text Font:(UIFont *)font;


//每一句首端距离左边距离
- (void)headIndentLength:(CGFloat)length;
//每一句末端距离左边边距离
- (void)tailIndentLength:(CGFloat)length;
//每一句首末距离左边的距离
- (void)headIndentLength:(CGFloat)headlength tailIndentLength:(CGFloat)taillength;
@end
