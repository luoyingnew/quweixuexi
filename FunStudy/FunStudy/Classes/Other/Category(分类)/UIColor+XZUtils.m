//
//  UIColor+XZUtils.m
//  NotAloneInTheDark
//
//  Created by hao on 16/12/9.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "UIColor+XZUtils.h"

@implementation UIColor (XZUtils)
+ (UIColor *)xz_defaultTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)xz_textWhiteColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_placeholderColor {
    return [UIColor colorFromHexStringRGBA:@"#9B9B9BFF"];
}

+ (UIColor *)xz_defaultViewBackgroundColor {
    return [UIColor blackColor];
}

+ (UIColor *)xz_blackBackgroundColor {
    return [UIColor blackColor];
}

+ (UIColor *)xz_buttonHightlightColor {
    return [UIColor colorFromHexStringRGBA:@"#EE074BFF"];
}

+ (UIColor *)xz_buttonNormalColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_buttonBackgroundViewColor {
    return [UIColor colorFromHexStringRGBA:@"#0F1215FF"];
}

+ (UIColor *)xz_defaultTextFieldColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_tabbarTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_tabbarTextUnselectedColor {
    return [UIColor grayColor];
}

+ (UIColor *)xz_navigationbarbarTintColor {
    return [UIColor colorFromHexStringRGBA:@"#101010FF"];
}

+ (UIColor *)xz_navigationbarTintColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_navigationbarTitleColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_tabbarColor {
    return [UIColor colorFromHexStringRGBA:@"#101010FF"];
}

+ (UIColor *)xz_rightBarbuttonItemTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_rightBarbuttonItemTextSelectedColor {
    return [UIColor grayColor];
}

+ (UIColor *)xz_videoAndAudioButtonBackgroundViewColor {
    return [UIColor colorFromHexStringRGBA:@"#0F1215FF"];
}

+ (UIColor *)xz_separatorLineColor {
    return [UIColor colorFromHexStringRGBA:@"#252525FF"];
}

+ (UIColor *)xz_circleButtonLight {
    return [UIColor colorFromHexStringRGBA:@"#4A4A4AFF"];
}

+ (UIColor *)colorFromHexStringRGBA:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF000000) >> 24)/255.0 green:((rgbValue & 0xFF0000) >> 16)/255.0 blue:((rgbValue & 0xFF00) >> 8)/255.0 alpha:(rgbValue & 0xFF)/255.0];
}

- (UIColor *)lighterColorRemoveSaturation:(CGFloat)removeS
                              resultAlpha:(CGFloat)alpha {
    CGFloat h,s,b,a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h
                          saturation:MAX(s - removeS, 0.0)
                          brightness:b
                               alpha:alpha == -1? a:alpha];
    }
    return nil;
}

- (UIColor *)lighterColor {
    return [self lighterColorRemoveSaturation:0.5
                                  resultAlpha:-1];
}

+ (UIColor *)xz_maskBlackTranslucentColor {
    return [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)xz_maskBlackColor {
    return [UIColor blackColor];
}

+ (UIColor *)xz_starSelectedColor {
    return [UIColor colorFromHexStringRGBA:@"#02FFB2FF"];
}

+ (UIColor *)xz_starUnSelectedColor {
    return [UIColor whiteColor];
}

+ (UIColor *)xz_hudColor {
    return [UIColor colorFromHexStringRGBA:@"#FCFCFCC8"];
}
@end
