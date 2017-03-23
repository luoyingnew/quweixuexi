//
//  JJTranslateModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJTranslateModel : NSObject
//正确的答案
@property (nonatomic, strong) NSString *rightAnswer;
//我选择的答案
@property (nonatomic, strong) NSString *myAnswer;
//小题id
@property (nonatomic, strong) NSString *unit_id;
//问题
@property (nonatomic, strong) NSString *question;
//答案
@property (nonatomic, strong) NSString *answer;
//大题描述
@property (nonatomic, strong) NSString *topic_title;

+(JJTranslateModel *)modelWithDictionary:(NSDictionary *)dic;
@end
