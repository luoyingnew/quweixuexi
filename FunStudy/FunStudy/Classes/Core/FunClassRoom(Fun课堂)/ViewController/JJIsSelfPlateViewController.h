//
//  JJIsSelfPlateViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2017/1/19.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJPlateModel.h"
#import "JJFunLessionModel.h"

@interface JJIsSelfPlateViewController : JJBaseViewController

//标题显示名称
@property (nonatomic, strong) NSString *name;

//最新作业||补作业||最新测验(最新测验不可能跳到本页面)
@property (nonatomic, strong) NSString *typeName;

@property (nonatomic, strong) JJFunLessionModel *model;


@end
