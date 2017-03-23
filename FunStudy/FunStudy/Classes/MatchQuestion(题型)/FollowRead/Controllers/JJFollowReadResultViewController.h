//
//  JJFollowReadResultViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJFollowReadModel.h"

@interface JJFollowReadResultViewController : JJBaseViewController

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSMutableArray<JJFollowReadModel *> *modelArray;

//该题对应的作业ID,主要用于提交答案时用
@property (nonatomic, strong) NSString *homeworkID;

//最新作业,最新测验,补作业
@property (nonatomic, strong) NSString *typeName;

@property(nonatomic,assign)BOOL isSelfStudy;//是否是自学中心跳转的
@end
