//
//  JJUnitModel.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJUnitModel.h"

@implementation JJUnitModel

//#pragma mark - json装换
//+(NSArray *)unitModelArrayWithDictArray:(NSArray *)array {
////    NSDictionary *dict1 = @{@"homework_id" : @"1", @"unit_title" : @"Lesson 1 There is a cat under the chair", @"plate_name" : @"Let's learn"};
////    NSDictionary *dict2 = @{@"homework_id" : @"2", @"unit_title" : @"Lesson 1 There is", @"plate_name" : @"Let's"};
////    NSDictionary *dict3 = @{@"homework_id" : @"1", @"unit_title" : @"Lesson 1 There is a cat under the chair", @"plate_name" : @"Let's learn"};
////    NSDictionary *dict5 = @{@"homework_id" : @"2", @"unit_title" : @"Lesson 1 Theresdfs is", @"plate_name" : @"Let's"};
////    
////    NSDictionary *dict4 = @{@"homework_id" : @"2", @"unit_title" : @"Lesson 1 There is", @"plate_name" : @"Let's"};
////    NSDictionary *dict6 = @{@"homework_id" : @"2", @"unit_title" : @"Lesson 1 Theasasresdfs is", @"plate_name" : @"Let's"};
////    
////    NSArray *arr = @[dict1,dict5,dict2,/Users/tangtiancheng/Desktop/ProjectGitLab/fun-IOS/FunStudy/FunStudy/Classes/FunHomeWorkList(作业列表)/Model/JJUnitModel.mdict3,dict6,dict4];
//    
//    NSMutableArray<NSDictionary *> *unitDicMutableArray = [NSMutableArray array];
//    //结题思路,遍历取出就数组中的每个字典,看看字典中的unit_title字段与新unit数组中的哪一个字典的unit_title相同,有相同的话则将plate_name和homework_id组成一个新字典放入对应字典的属性中
//    for(NSDictionary *dict in array) {
//        BOOL isEqualUnitTitle = NO;
//        for(NSDictionary *unitDict in unitDicMutableArray) {
//            if([dict[@"unit_title"] isEqualToString:unitDict[@"unit_title"]]) {
//                isEqualUnitTitle = YES;
//                //如果有相同的
//                NSMutableArray *plateDictArray = unitDict[@"plateDictArray"];
//                NSDictionary *plateDict = @{@"plate_name" : dict[@"plate_name"], @"homework_id" : dict[@"homework_id"]};
//                [plateDictArray addObject:plateDict];
//                break;
//            }
//        }
//        if(!isEqualUnitTitle) {
//            NSMutableArray *plateDictArray = [NSMutableArray array];
//            [plateDictArray addObject:@{@"plate_name" : dict[@"plate_name"], @"homework_id" : dict[@"homework_id"]}];
//            NSDictionary *unitDict = @{@"unit_title" : dict[@"unit_title"], @"plateDictArray" : plateDictArray};
//            [unitDicMutableArray addObject:unitDict];
//        }
//    }
//    
//    NSArray<JJUnitModel *> *modelArray = [JJUnitModel mj_objectArrayWithKeyValuesArray:unitDicMutableArray];
//    return modelArray;
//}


//+(NSDictionary *)mj_objectClassInArray {
//    return @{@"plateDictArray" : [JJPlateModel class]};
//}

//#pragma mark - 懒加载
//- (NSMutableArray *)plateDictArray {
//    if(!_plateDictArray) {
//        _plateDictArray = [NSMutableArray array];
//    }
//    return _plateDictArray;
//}

@end
