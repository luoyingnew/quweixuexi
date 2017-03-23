//
//  NSDate+Age.m
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/17.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "NSDate+Age.h"

@implementation NSDate (Age)

- (NSString *)currentAge {
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    
    //用来得到具体的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date1 = [calendar components:unitFlags fromDate:self toDate:nowDate options:0];
    
    if([date1 year] >0)
    {
        return [NSString stringWithFormat:(@"%ld岁%ld个月"),(long)[date1 year],(long)[date1 month]] ;
    }
    else if([date1 month] >0)
    {
        return [NSString stringWithFormat:(@"%ld个月%ld天"),(long)[date1 month],(long)[date1 day]];
    }
    else if([date1 day]>0){
        return [NSString stringWithFormat:(@"%ld天"),(long)[date1 day]];
    }
    else {
        return @"0天";
    }
}

/**
 *  格式
 yyyy-MM-dd HH:mm:ss.SSS
 yyyy-MM-dd HH:mm:ss
 yyyy-MM-dd
 MM dd yyyy
 */
+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSString *)string:(NSString *)dateString ChangeToDate:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateString.floatValue];
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    if(format == nil){
        formatter.dateFormat=@"yyyy-MM-dd";
    }else{
        formatter.dateFormat=format;
    }
    NSString* birthString=[formatter stringFromDate:date];
    return birthString;
}



@end
