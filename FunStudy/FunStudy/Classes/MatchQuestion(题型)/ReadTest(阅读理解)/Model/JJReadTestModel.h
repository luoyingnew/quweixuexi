//
//  JJReadTestModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJReadTestProblemModel.h"
#import "JJReadTestModel.h"

@interface JJReadTestModel : NSObject


//短文
@property (nonatomic, strong) NSString *passage;
//大题描述
@property (nonatomic, strong) NSString *topic_title;
//问题列表
@property (nonatomic, strong) NSArray<JJReadTestProblemModel *> *questionList;

+ (JJReadTestModel *)modelWithDictionary:(NSDictionary *)dic;

@end
