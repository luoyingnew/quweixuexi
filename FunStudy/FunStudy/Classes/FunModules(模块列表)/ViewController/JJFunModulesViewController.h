//
//  JJFunModulesViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2017/1/5.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJFunLessionModel.h"
#import "JJBookModel.h"

@interface JJFunModulesViewController : JJBaseViewController
//书本model,为了拿到书本名
@property (nonatomic, strong) JJBookModel *bookModel;

@property (nonatomic, strong) JJFunLessionModel *model;

@end
