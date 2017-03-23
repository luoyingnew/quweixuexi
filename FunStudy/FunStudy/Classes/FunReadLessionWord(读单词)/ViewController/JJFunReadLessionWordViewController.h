//
//  JJFunReadLessionWordViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJFunLessionModel.h"
#import "JJBookModel.h"
#import "JJFunModulModel.h"

@interface JJFunReadLessionWordViewController : JJBaseViewController
//书本
@property (nonatomic, strong) JJBookModel *bookModel;

//模块数组
@property (nonatomic, strong) JJFunModulModel *modulModel;

////单元数组
//@property (nonatomic, strong) NSArray <JJFunLessionModel *>*lessionModelArray;
////当前的lession处于数组第几个
//@property (nonatomic, assign) NSInteger currentLessionIndex;

@end
