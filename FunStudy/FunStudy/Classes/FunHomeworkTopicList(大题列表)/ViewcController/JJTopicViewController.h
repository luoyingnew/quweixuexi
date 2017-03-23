//
//  JJTopicViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJHomeWorkModel.h"

typedef void(^RefeshHomeworkListBlock)(void);

@interface JJTopicViewController : JJBaseViewController

//是否是自学中心跳转的
@property(nonatomic,assign)BOOL isSelfStudy;

@property (nonatomic, strong) JJHomeWorkModel *model;

//最新作业||补作业||最新测验
@property (nonatomic, strong) NSString *name;

//当为初中作业时才会回调
@property (nonatomic, copy) RefeshHomeworkListBlock refeshHomeworkListBlock;


@end
