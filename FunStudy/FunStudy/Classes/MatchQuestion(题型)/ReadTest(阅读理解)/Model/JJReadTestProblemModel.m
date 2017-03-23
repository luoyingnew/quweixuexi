//
//  JJReadTestProblemModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReadTestProblemModel.h"

@implementation JJReadTestProblemModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"optionModelList" : [JJSingleChooseOptionalModel class]};
}

+ (JJReadTestProblemModel *)modelWithDictionary:(NSDictionary *)dic {
    JJReadTestProblemModel *readTestProblemModel = [[JJReadTestProblemModel alloc]init];
    readTestProblemModel.rightAnswer = dic[@"option_right"];
    readTestProblemModel.myAnswer = @"X";
    readTestProblemModel.unit_id = dic[@"unit_id"];
    readTestProblemModel.order = [dic[@"order"] integerValue];
    readTestProblemModel.question = dic[@"topic_text"];
    
    JJSingleChooseOptionalModel *modelA = [[JJSingleChooseOptionalModel alloc]init];
    modelA.letter = @"A";
    modelA.word = dic[@"option_a"];
    if([dic[@"option_tag"] isKindOfClass:[NSArray class]] && [dic[@"option_tag"] count] >= 1) {
        modelA.option_tag = dic[@"option_tag"][0];
    }
    
    JJSingleChooseOptionalModel *modelB = [[JJSingleChooseOptionalModel alloc]init];
    modelB.letter = @"B";
    modelB.word = dic[@"option_b"];
    if([dic[@"option_tag"] isKindOfClass:[NSArray class]] && [dic[@"option_tag"] count] >= 2) {
        modelB.option_tag = dic[@"option_tag"][1];
    }
    
    JJSingleChooseOptionalModel *modelC = [[JJSingleChooseOptionalModel alloc]init];
    modelC.letter = @"C";
    modelC.word = dic[@"option_c"];
    if([dic[@"option_tag"] isKindOfClass:[NSArray class]] && [dic[@"option_tag"] count] >= 3) {
        modelC.option_tag = dic[@"option_tag"][2];
    }
     JJSingleChooseOptionalModel *modelD = [[JJSingleChooseOptionalModel alloc]init];
    modelD.letter = @"D";
    modelD.word = dic[@"option_d"];
    if([dic[@"option_tag"] isKindOfClass:[NSArray class]] && [dic[@"option_tag"] count] >= 4) {
        modelD.option_tag = dic[@"option_tag"][3];
    }
    readTestProblemModel.optionModelList = @[modelA,modelB,modelC,modelD];
    return readTestProblemModel;
}

@end
