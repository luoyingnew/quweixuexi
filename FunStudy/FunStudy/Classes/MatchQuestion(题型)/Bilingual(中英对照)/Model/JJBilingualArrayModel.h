//
//  JJBilingualArrayModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJBilingualModel.h"
#import "JJBilingualResultModel.h"


@interface JJBilingualArrayModel : NSObject

//从服务器拿的数据
@property (nonatomic, strong) NSArray<JJBilingualModel *> *bilingualModelArray;

//这个数组是从bilingualModelArray中将option_right拿出来组成数组再打乱,目的是为了给右边那排按钮赋值
@property (nonatomic, strong)NSMutableArray<NSString *> *rightBtnTextArray;
//(其实写一个数组就可以了,写两个是为了更加直观)
//连线关系数组左端
@property (nonatomic, strong) NSMutableArray *leftlineRelationArray;
//连线关系数组右端
@property (nonatomic, strong) NSMutableArray *rightlineRelationArray;

@end
