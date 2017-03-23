//
//  Util.h
//  HiFun
//
//  Created by attackt on 16/8/4.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

/**
 * 获取当前系统的语言
 * iOS9.0之前          zh-Hans:简体中文    en:英文
 * iOS9.0和iOS9.0之后  zh-Hans-CN:简体中文 en-CN:英文
 * 建议的判断方式是 if ([[Util getPreferredLanguage] hasPrefix:@"zh-Hans"])
 */
+ (NSString *)getPreferredLanguage;

/**
 *  是否纯数字
 */
+ (BOOL)isPureInt:(NSString*)string;

/**
 *  是否为合法的手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  是否为数字和字母
 */
+ (BOOL)isNumberAndChar:(NSString *)string;

/**
 * 将 image 进行 base64 转码
 */
+ (NSString *)base64WithImage:(UIImage *)image;

/**
 *  将 base64字符串转为 image
 */
+ (UIImage *)imageWithBase64String:(NSString *)string;

/**
 *  JSON字符串转NSDictionary
 */
+ (NSDictionary *)JsonStringToDictionary:(NSString *)jsonString;

/**
 *  NSDictionary转 JSON
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/**
 *  NSArray转 JSON
 */
+ (NSString*)arrayToJson:(NSArray *)arr;
/**
 *  网络实时状态的判断
 */
+ (BOOL)isNetWorkEnable;

/**
 获取客户端ip
 */
+ (NSString *)getClientIP;

/**
 * 只含有汉语、英文字符、数字、下划线
 */
+ (BOOL)isValiteNum_Char_CNStr:(NSString *)string;

/**
 * //判断一个字符串是否是纯数字
 */
+ (BOOL)ismathNumberWithString:(NSString *)string;
/**
 * 是否含有 emoji 表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;


/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeFontAndColor:(UIFont *)font
                                            Color:(UIColor *)color
                                      TotalString:(NSString *)totalString
                                   SubStringArray:(NSArray *)subArray;

/**
 截屏的方法
 
 @param screenView 需要截取的view
 
 @return 截取的image
 */
+ (UIImage *)captureWithView:(UIView *)screenView;



/**
 计算文本的高度
 
 @param width 显示的宽度
 @param size  显示的文字字体
 @param text  显示的的文字
 
 @return 文本的高度
 */
+ (CGFloat) calculateTextHeightByWidth:(CGFloat)width fontSize:(CGFloat)size text:(NSString *)text;



@end
