//
//  UIColor+XZUtils.h
//  NotAloneInTheDark
//
//  Created by hao on 16/12/9.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XZUtils)
+ (UIColor *)xz_defaultTextColor;
+ (UIColor *)xz_textWhiteColor;
+ (UIColor *)xz_placeholderColor;
+ (UIColor *)xz_defaultViewBackgroundColor;
+ (UIColor *)xz_blackBackgroundColor;
+ (UIColor *)xz_buttonHightlightColor;
+ (UIColor *)xz_buttonNormalColor;
+ (UIColor *)xz_buttonBackgroundViewColor;
+ (UIColor *)xz_defaultTextFieldColor;

+ (UIColor *)xz_tabbarTextColor;
+ (UIColor *)xz_tabbarTextUnselectedColor;

+ (UIColor *)xz_navigationbarbarTintColor;
+ (UIColor *)xz_navigationbarTintColor;
+ (UIColor *)xz_navigationbarTitleColor;
+ (UIColor *)xz_tabbarColor;
+ (UIColor *)xz_rightBarbuttonItemTextColor;
+ (UIColor *)xz_rightBarbuttonItemTextSelectedColor;

+ (UIColor *)xz_videoAndAudioButtonBackgroundViewColor;

+ (UIColor *)xz_separatorLineColor;

+ (UIColor *)colorFromHexStringRGBA:(NSString *)hexString;

- (UIColor *)lighterColor;

+ (UIColor *)xz_maskBlackTranslucentColor;
+ (UIColor *)xz_maskBlackColor;
+ (UIColor *)xz_circleButtonLight;
+ (UIColor *)xz_starSelectedColor;
+ (UIColor *)xz_starUnSelectedColor;
+ (UIColor *)xz_hudColor;
@end
