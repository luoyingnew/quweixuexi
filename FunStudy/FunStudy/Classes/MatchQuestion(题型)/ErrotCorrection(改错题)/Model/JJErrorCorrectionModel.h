//
//  JJErrorCorrectionModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJErrorCorrectionModel : NSObject

//我选择的答案
@property (nonatomic, strong) NSString *myAnswer;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *rightAnswer;
//小题id
@property (nonatomic, strong) NSString *unit_id;
//大题描述
@property (nonatomic, strong) NSString *topic_title;


+(JJErrorCorrectionModel *)modelWithDictionary:(NSDictionary *)dic;

@end
