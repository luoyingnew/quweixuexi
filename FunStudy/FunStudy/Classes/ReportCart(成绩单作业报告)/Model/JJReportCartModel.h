//
//  JJReportCartModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJReportCartCellModel.h"

@interface JJReportCartModel : NSObject

@property (nonatomic, strong) NSString *score_avg;//作业平均成绩
@property (nonatomic, strong) NSArray<JJReportCartCellModel *> *report_list;//作业列表

@end
