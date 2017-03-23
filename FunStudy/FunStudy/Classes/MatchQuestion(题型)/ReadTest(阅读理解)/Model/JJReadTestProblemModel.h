//
//  JJReadTestProblemModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJSingleChooseOptionalModel.h"

@interface JJReadTestProblemModel : NSObject
//正确的答案
@property (nonatomic, strong) NSString *rightAnswer;

//我选择的答案
@property (nonatomic, strong) NSString *myAnswer;
//小题id
@property (nonatomic, strong) NSString *unit_id;
//第几问
@property(nonatomic,assign)NSInteger order;
//问题
@property (nonatomic, strong) NSString *question;
//答案列表
@property (nonatomic, strong) NSArray<JJSingleChooseOptionalModel *> *optionModelList;

+ (JJReadTestProblemModel *)modelWithDictionary:(NSDictionary *)dic;
@end
