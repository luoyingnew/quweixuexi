//
//  JJScoreDetailModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/1.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJScoreDetailModel.h"

@implementation JJScoreDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"topics" : [JJScoreDetailTopicModel class]};
}

@end
