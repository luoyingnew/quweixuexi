//
//  JJReadTestModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJReadTestModel.h"

@implementation JJReadTestModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"questionList" : [JJReadTestProblemModel class]};
}

+ (JJReadTestModel *)modelWithDictionary:(NSDictionary *)dic {
    JJReadTestModel *readTestModel = [[JJReadTestModel alloc]init];
    readTestModel.passage = dic[@"topic_content"];
    
    NSArray<NSDictionary *> *readTestProblemModelArray = dic[@"content"];
    NSMutableArray *arrayM = [NSMutableArray array];
    for(NSDictionary *dictionary in readTestProblemModelArray) {
        
//        NSMutableDictionary *di = [NSMutableDictionary dictionaryWithDictionary:dictionary];
//        di[@"option_tag"] = @"u";
        
        [arrayM addObject:[JJReadTestProblemModel modelWithDictionary:dictionary]];
    }
    readTestModel.questionList = arrayM;
    return readTestModel;
}
@end
