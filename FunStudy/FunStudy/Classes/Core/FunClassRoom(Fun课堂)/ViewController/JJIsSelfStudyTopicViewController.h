//
//  JJIsSelfStudyTopicViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2017/1/19.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJHomeWorkModel.h"
#import "JJFunLessionModel.h"

typedef void(^RefeshHomeworkListBlock)(void);
@interface JJIsSelfStudyTopicViewController : JJBaseViewController

@property (nonatomic, strong) JJFunLessionModel *model;

//当为初中作业时才会回调
@property (nonatomic, copy) RefeshHomeworkListBlock refeshHomeworkListBlock;
@end
