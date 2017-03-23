//
//  JJBilingualView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/20.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJBilingualModel.h"
#import "JJBilingualArrayModel.h"

//已经匹配的个数   和全部个数
//typedef void(^BilingualBlock)(int currentCount,int allCount);

@interface JJBilingualView : UIView

@property (nonatomic, strong) JJBilingualArrayModel *model;










//
////@property (nonatomic, copy) BilingualBlock bilingualBlock;
//
//
////这个数组是从外面拿过来的,目的是为了给左边那排按钮赋值,并且最后用于判断对错
//@property (nonatomic, strong) NSArray<JJBilingualModel *> *bilingualModelArray;
////这个数组是从bilingualModelArray中将option_right拿出来组成数组再打乱,目的是为了给右边那排按钮赋值
//@property (nonatomic, strong)NSMutableArray<NSString *> *rightBtnTextArray;
//
//
//
////(其实写一个数组就可以了,写两个是为了更加直观)
////连线关系数组左端
//@property (nonatomic, strong) NSMutableArray *leftlineRelationArray;
////连线关系数组右端
//@property (nonatomic, strong) NSMutableArray *rightlineRelationArray;

@end
