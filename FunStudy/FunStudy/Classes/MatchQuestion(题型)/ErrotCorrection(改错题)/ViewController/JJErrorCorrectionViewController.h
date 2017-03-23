//
//  JJErrorCorrectionViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJTopicModel.h"

@interface JJErrorCorrectionViewController : JJBaseViewController

@property (nonatomic, strong) JJTopicModel *topicModel;
//表示是最新作业(补作业)还是最新测验
@property (nonatomic, strong) NSString *name;
//标题展示名称
@property (nonatomic, strong) NSString *navigationTitleName;
@end
