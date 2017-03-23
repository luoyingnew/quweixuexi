//
//  JJBilingualArrayModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBilingualArrayModel.h"

@implementation JJBilingualArrayModel
#pragma mark - MJ
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"bilingualModelArray" : @"content"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{@"bilingualModelArray" : [JJBilingualModel class]};
}

#pragma mark - setmodel
//setmodel
- (void)setBilingualModelArray:(NSArray<JJBilingualModel *> *)bilingualModelArray{
    _bilingualModelArray = bilingualModelArray;
    for(JJBilingualModel *model in bilingualModelArray) {
        [self.rightBtnTextArray addObject:model.option_desc];
    }
    [self randamArry:self.rightBtnTextArray];
}

//将一个可变数组乱序
- (void)randamArry:(NSMutableArray *)arry
{
    NSArray *arrayCurrent = [arry sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    for (NSString *str in arrayCurrent) {
        NSLog(@"%@", str);
    }
    [arry removeAllObjects];
    [arry addObjectsFromArray:arrayCurrent];
}


#pragma mark - 懒加载
- (NSMutableArray *)leftlineRelationArray {
    if(!_leftlineRelationArray) {
        _leftlineRelationArray = [NSMutableArray array];
        for(int i = 0;i<self.self.bilingualModelArray.count; i++) {
            [_leftlineRelationArray addObject:@(-1)];
        }
    }
    return _leftlineRelationArray;
}
- (NSMutableArray *)rightlineRelationArray {
    if(!_rightlineRelationArray) {
        _rightlineRelationArray = [NSMutableArray array];
        for(int i = 0;i<self.bilingualModelArray.count;i++) {
            [_rightlineRelationArray addObject:@(-1)];
        }
    }
    return _rightlineRelationArray;
}
- (NSMutableArray *)rightBtnTextArray {
    if(!_rightBtnTextArray) {
        _rightBtnTextArray = [NSMutableArray array];
    }
    return _rightBtnTextArray;
}
@end
