//
//  JJScoreDetailSecondModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJScoreDetailSecondModel.h"


@implementation JJScoreDetailSecondModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"topic_list" : [JJScoreDetailTopicSecondModel class]};
}

@end
