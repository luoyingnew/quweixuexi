//
//  SetModel.m
//  FunStudy
//
//  Created by tang on 16/11/11.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "SetModel.h"

@implementation SetModel
+ (instancetype)configTitle:(NSString *)title icon:(NSString *)arrow
{
    SetModel *model = [[self alloc]init];
    model.title = title;
    model.arrow = arrow;
    return model;
}
+ (instancetype)configTitle:(NSString *)title icon:(NSString *)arrow type:(JJSetType)type
{
    SetModel *model = [[self alloc]init];
    model.title = title;
    model.arrow = arrow;
    model.type = type;
    return model;
}
@end
