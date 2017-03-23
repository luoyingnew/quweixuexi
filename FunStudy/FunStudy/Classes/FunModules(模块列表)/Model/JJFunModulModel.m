//
//  JJFunModulModel.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/5.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJFunModulModel.h"

@implementation JJFunModulModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"word_list" : [JJWordModel class]};
}

@end
