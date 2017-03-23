//
//  JJPlateModel.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJPlateModel.h"

@implementation JJPlateModel

+(NSArray *)plateModelArrayWithDictArray:(NSArray *)array {
    NSMutableArray *plateModelArrayM = [NSMutableArray array];
    for(NSDictionary *dict in array) {
        BOOL isEqualPlateName = NO;
        for(NSDictionary *plateDict in plateModelArrayM) {
            if([dict[@"plate_name"] isEqualToString:plateDict[@"plate_name"]]) {
                isEqualPlateName = YES;
                //如果有相同的
                NSMutableArray *plateDictArray = plateDict[@"topicDictArray"];
                [plateDictArray addObject:dict];
                break;
            }
        }
        if(!isEqualPlateName) {
            NSMutableArray *topicDictArray = [NSMutableArray array];
            [topicDictArray addObject:dict];
            NSDictionary *plateDict = @{@"plate_name" : dict[@"plate_name"], @"plate_id" : dict[@"plate_id"], @"topicDictArray" : topicDictArray};
            [plateModelArrayM addObject:plateDict];
        }
    }
    return plateModelArrayM;
}


+(NSDictionary *)mj_objectClassInArray {
    return @{@"topicDictArray" : [JJTopicModel class]};
}

- (NSMutableArray *) topicDictArray{
    if(!_topicDictArray) {
        _topicDictArray = [NSMutableArray array];
    }
    return _topicDictArray;
}
@end
