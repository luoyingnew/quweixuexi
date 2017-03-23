//
//  UIFont+common.m
//  MCEnglish
//
//  Created by lwb on 2017/2/15.
//  Copyright © 2017年 Attackt. All rights reserved.
//

#import "UIFont+common.h"

@implementation UIFont (common)

+ (UIFont *)phonoTypeFontWithSize:(CGFloat)size {
    NSString *fontPath = [[NSBundle mainBundle]pathForResource:@"YBNew" ofType:@"TTF"];
    NSURL *fontURL = [NSURL fileURLWithPath:fontPath];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontURL);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    NSString *fontName = (__bridge NSString *)CGFontCopyFullName(fontRef);
    UIFont *font = [UIFont fontWithName:fontName size:size ];
    CGFontRelease(fontRef);
    return font;
}
@end
