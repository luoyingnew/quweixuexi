//
//  JJReportCartModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReportCartModel.h"

@implementation JJReportCartModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"report_list" : [JJReportCartCellModel class]};
}

@end
