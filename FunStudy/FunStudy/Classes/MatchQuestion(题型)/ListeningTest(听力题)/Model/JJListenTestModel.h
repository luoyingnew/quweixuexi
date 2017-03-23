//
//  JJListenTestModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJSingleChooseOptionalModel.h"

@interface JJListenTestModel : NSObject

//小题id
@property (nonatomic, strong) NSString *unit_id;

//正确的答案
@property (nonatomic, strong) NSString *rightAnswer;

//我选择的答案
@property (nonatomic, strong) NSString *myAnswer;

//听力音频地址
@property (nonatomic, strong) NSString *file_video;
//大题描述
@property (nonatomic, strong) NSString *topic_title;
//答案列表
@property (nonatomic, strong) NSArray<JJSingleChooseOptionalModel *> *optionModelList;

+ (JJListenTestModel *)modelWithDictionary:(NSDictionary *)dic;

@end
