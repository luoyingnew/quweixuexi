//
//  JJHomeWorkModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJHomeWorkModel.h"

@implementation JJHomeWorkModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    JJHomeWorkModel *model = [[JJHomeWorkModel alloc]init];
    if(dict[@"exam_id"]) {
        model.homework_id = dict[@"exam_id"];
    } else {
        model.homework_id = dict[@"sys_homework_id"];
    }
    if(dict[@"exam_title"]) {
        model.homework_title = dict[@"exam_title"];
    } else {
        model.homework_title = dict[@"homework_title"];
    }
    
    model.topics_count = [dict[@"topics_count"] intValue];
    return model;
}

@end
