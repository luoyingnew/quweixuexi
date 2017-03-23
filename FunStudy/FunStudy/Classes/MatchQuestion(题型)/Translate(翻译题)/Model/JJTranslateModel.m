//
//  JJTranslateModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJTranslateModel.h"

@implementation JJTranslateModel

+(JJTranslateModel *)modelWithDictionary:(NSDictionary *)dic {
    JJTranslateModel *translateModel = [[JJTranslateModel alloc]init];
    translateModel.unit_id = dic[@"unit_id"];
    translateModel.question = dic[@"topic_text"];
    translateModel.answer = dic[@"option_right"];
    translateModel.myAnswer = @"X";
    return translateModel;
}

@end
