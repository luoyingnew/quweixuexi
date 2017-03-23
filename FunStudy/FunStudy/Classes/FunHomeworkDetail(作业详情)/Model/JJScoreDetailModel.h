//
//  JJScoreDetailModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJScoreDetailTopicModel.h"
#import "JJFunTrackModel.h"

@interface JJScoreDetailModel : NSObject

@property (nonatomic, strong) NSString *endtime;//布置作业结束时间
@property (nonatomic, strong) NSString *score;//分数
@property (nonatomic, strong) NSString *class_avg_score;//班级平均分数
@property (nonatomic, assign) JJFunTrackType eh_type;//1代表作业，2代表测验
@property (nonatomic, strong) NSArray<JJScoreDetailTopicModel *> *topics;


@end
