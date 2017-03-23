//
//  JJHomeWorkDetailViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

//该控制器用于两个地方,一个地方是Fun足迹中点击查看的   还有一个地方是我的成绩->作业报告->再点击作业列表

#import "JJBaseViewController.h"
#import "JJFunTrackModel.h"

@interface JJHomeWorkDetailViewController : JJBaseViewController
//Fun足迹中点击查看的
@property (nonatomic, strong) JJFunTrackModel *model;


//我的成绩->作业报告->再点击作业列表点击
@property (nonatomic, strong) NSString *homework_id;


@end
