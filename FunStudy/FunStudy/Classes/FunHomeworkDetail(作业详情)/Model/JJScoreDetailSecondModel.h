//
//  JJScoreDetailSecondModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJScoreDetailTopicSecondModel.h"

@interface JJScoreDetailSecondModel : NSObject

@property (nonatomic, strong) NSString *score_avg;//班级平均分
@property (nonatomic, strong) NSString *start_homework;//作业开始时间
@property (nonatomic, strong) NSString *score_homework;//自己作业得分
@property (nonatomic, strong) NSArray<JJScoreDetailTopicSecondModel *> *topic_list;//列表

@end
