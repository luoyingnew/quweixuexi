//
//  JJScoreDetailTopicSecondModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJTopicModel.h"

@interface JJScoreDetailTopicSecondModel : NSObject

@property (nonatomic, strong) NSString *score__sum;//大题总得分
@property (nonatomic, assign) TopicType child_type;//大题类型
@property (nonatomic, strong) NSString *topic_id;//大题id

@end
