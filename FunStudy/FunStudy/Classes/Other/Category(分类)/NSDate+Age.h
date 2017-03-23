//
//  NSDate+Age.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Age)

/**
 根据date日期获得年龄

 @return 年龄
 */
- (NSString *)currentAge;

/*
 *  date 转 string
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 *  string 转 date
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

//将字符串时间戳转为日期
+ (NSString *)string:(NSString *)dateString ChangeToDate:(NSString *)format;

@end
