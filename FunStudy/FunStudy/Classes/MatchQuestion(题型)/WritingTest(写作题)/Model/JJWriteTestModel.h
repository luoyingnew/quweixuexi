//
//  JJWriteTestModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/24.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJWriteTestModel : NSObject

@property (nonatomic, strong) NSString *topic_text;
@property (nonatomic, strong) NSString *unit_id;
@property (nonatomic, strong) NSString *option_right;

//大题描述
@property (nonatomic, strong) NSString *topic_title;
//我选择的答案
@property (nonatomic, strong) NSString *myAnswer;


@end
