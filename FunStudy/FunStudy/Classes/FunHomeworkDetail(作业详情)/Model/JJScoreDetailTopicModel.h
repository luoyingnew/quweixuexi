//
//  JJScoreDetailTopicModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJFunTrackModel.h"


@interface JJScoreDetailTopicModel : NSObject


@property (nonatomic, strong) NSString *topic_title;//大题名称
@property (nonatomic, strong) NSString *topic_score;//分数

@property (nonatomic, assign) JJFunTrackType eh_type;//1代表作业，2代表测验(主要是因为小学作业要隐藏成绩)

@end
