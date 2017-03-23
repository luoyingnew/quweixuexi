//
//  JJHomeworkListViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJHomeworkListViewController : JJBaseViewController

//头部名称(最新作业|最新测验||补作业)
@property (nonatomic, copy) NSString *name;

//一下三个主要是自学用户点击单元跳转到本控制器时需要
//是否是自学中心跳转的
@property(nonatomic,assign)BOOL isSelfStudy;
//教材id
@property (nonatomic, strong) NSString *book_id;
//单元id
@property (nonatomic, strong) NSString *unit_id;

@end
