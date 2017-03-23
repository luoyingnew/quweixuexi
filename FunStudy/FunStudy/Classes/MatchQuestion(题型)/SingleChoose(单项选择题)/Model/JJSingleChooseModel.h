//
//  JJSingleChooseModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJSingleChooseOptionalModel.h"

typedef NS_ENUM(NSInteger, SingleChooseTestType){
    SingleChooseText,//文字
    SingleChooseImageView,//图片
};

@interface JJSingleChooseModel : NSObject
//正确的答案
@property (nonatomic, strong) NSString *rightAnswer;

//我选择的答案
@property (nonatomic, strong) NSString *myAnswer;
//小题id
@property (nonatomic, strong) NSString *unit_id;
//文字还是图片
@property(nonatomic,assign)SingleChooseTestType type;
//问题
@property (nonatomic, strong) NSString *question;
//大题描述
@property (nonatomic, strong) NSString *topic_title;
//答案列表
@property (nonatomic, strong) NSArray<JJSingleChooseOptionalModel *> *optionModelList;

+ (JJSingleChooseModel *)modelWithDictionary:(NSDictionary *)dic;
@end
