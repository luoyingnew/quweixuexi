//
//  JJErrorCorrectionModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJErrorCorrectionModel.h"

@implementation JJErrorCorrectionModel

+(JJErrorCorrectionModel *)modelWithDictionary:(NSDictionary *)dic {
    JJErrorCorrectionModel *errorCorrectionModel = [[JJErrorCorrectionModel alloc]init];
    errorCorrectionModel.unit_id = dic[@"unit_id"];
    errorCorrectionModel.question = dic[@"topic_text"];
    errorCorrectionModel.rightAnswer = dic[@"option_right"];
    errorCorrectionModel.myAnswer = @"X";
    return errorCorrectionModel;
}


@end
